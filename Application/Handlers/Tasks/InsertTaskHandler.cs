using Application.Core;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Tasks;
using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.Resources;
using Domain.DataModels.Complaints;
using Application.Commands;
using Application.Services;
using Domain.DataModels.Notifications;
using Domain.Helpers;
using System.Threading.Tasks;

namespace Application.Handlers.Tasks
{
    public class InsertTaskHandler : IRequestHandler<InsertTaskCommand, Result<TaskDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;
        public readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public InsertTaskHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler transactionHandler,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _context = context;
            _userManager = userManager;
            _transactionHandler = transactionHandler;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<TaskDTO>> Handle(
            InsertTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            var taskDTO = request.TaskDTO;
            int userId = await _context.Users
                .Where(q => q.UserName == taskDTO.strUserName)
                .Select(q => q.Id)
                .FirstOrDefaultAsync();

            var blnIsFromSameRegion =
                await _context.Complaints
                    .Where(q => request.TaskDTO.lstComplaintIds.Contains(q.intId))
                    .Select(q => q.intRegionId)
                    .Distinct()
                    .CountAsync() == 1;

            var blnHasCorrectStatus =
                await _context.Complaints
                    .Where(
                        q =>
                            request.TaskDTO.lstComplaintIds.Contains(q.intId)
                            && (
                                q.intStatusId == (int)ComplaintsConstant.complaintStatus.refiled
                                || q.intStatusId == (int)ComplaintsConstant.complaintStatus.pending
                            )
                    )
                    .Select(q => q.intId)
                    .CountAsync() == request.TaskDTO.lstComplaintIds.Count();

            if (blnHasCorrectStatus == false)
                return Result<TaskDTO>.Failure(
                    "Tasks could only be created for pending or refiled complaints."
                );

            if (blnIsFromSameRegion == false)
                return Result<TaskDTO>.Failure(
                    "Not all selected complaints are within the same region."
                );

            try
            {
                //Tasks table
                var task = new WorkTask //Date Activated and Date Finished should be null
                {
                    intAdminId = userId,
                    intStatusId = (int)TasksConstant.taskStatus.inactive,
                    intTypeId = request.TaskDTO.intTaskType,
                    decCost = request.TaskDTO.decCost ?? 0.00m,
                    dtmDateScheduled = request.TaskDTO.scheduledDate,
                    dtmDateDeadline = request.TaskDTO.deadlineDate,
                    intLastModifiedBy = userId,
                    strComment = request.TaskDTO.strComment,
                    dtmDateLastModified = DateTime.Now,
                    decRating = 0,
                    intTeamId = request.TaskDTO.intTeamId,
                    blnIsDeleted = false
                };
                var taskEntity = await _context.Tasks.AddAsync(task);
                await _context.SaveChangesAsync(cancellationToken);

                if (request.TaskDTO.lstComplaintIds.Count == 0)
                    return Result<TaskDTO>.Failure("Choose complaint(s)");
                //TaskComplaints table

                foreach (int complaintId in request.TaskDTO.lstComplaintIds)
                {
                    var taskComplaint = new WorkTaskComplaints
                    {
                        intTaskId = taskEntity.Entity.intId,
                        intComplaintId = complaintId
                    };

                    await _context.TasksComplaints.AddAsync(taskComplaint);

                    // send notifications to users that their complaint is in progress
                    try
                    {
                        //Insert into Notifications Table

                        var ComplaintUserId = await _context.Complaints
                            .Where(q => q.intId == complaintId)
                            .Select(c => c.intUserID)
                            .SingleOrDefaultAsync();

                        var username = await _context.Users
                            .Where(q => q.Id == ComplaintUserId)
                            .Select(c => c.UserName)
                            .SingleOrDefaultAsync();

                        // Get Notification body and header
                        var notificationLayout = await _context.NotificationTypes
                            .Where(
                                q =>
                                    q.intId
                                    == (int)
                                        NotificationConstant
                                            .NotificationType
                                            .complaintStatusChangeNotification
                            )
                            .Select(
                                q =>
                                    new NotificationLayout
                                    {
                                        strHeaderAr = q.strHeaderAr,
                                        strBodyAr = q.strBodyAr,
                                        strBodyEn = q.strBodyEn,
                                        strHeaderEn = q.strHeaderEn
                                    }
                            )
                            .SingleOrDefaultAsync();

                        if (notificationLayout == null)
                            throw new Exception("Notification Type table is empty");

                        string headerAr = notificationLayout.strHeaderAr;
                        string bodyAr =
                            notificationLayout.strBodyAr
                            + " #"
                            + complaintId
                            + " إلى 'مجدول'. سيتم مراجعة شكوتك من قبل فريقنا وسنقوم بإعلامك بأي تحديثات جديدة. نشكرك على صبرك.";
                        string headerEn = notificationLayout.strHeaderEn;
                        string strBodyEn =
                            notificationLayout.strBodyEn
                            + " #"
                            + complaintId
                            + " has been updated to 'Scheduled' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.";

                        await _mediator.Send(
                            new InsertNotificationCommand(
                                new Notification
                                {
                                    intTypeId = (int)
                                        NotificationConstant
                                            .NotificationType
                                            .complaintStatusChangeNotification,
                                    intUserId = ComplaintUserId,
                                    strHeaderAr = headerAr,
                                    strBodyAr = bodyAr,
                                    strHeaderEn = headerEn,
                                    strBodyEn = strBodyEn,
                                }
                            )
                        );

                        //await _notificationService.SendNotification(ComplaintUserId, headerAr, bodyAr);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                    }
                }

                //Complaints Table
                foreach (int complaintId in request.TaskDTO.lstComplaintIds)
                {
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;
                    await _context.SaveChangesAsync(cancellationToken);

                    //Complaints_statuses Table
                    await _transactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                            complaintId,
                            (int)ComplaintsConstant.complaintStatus.Scheduled
                        ),
                        cancellationToken
                    );

                    await _context.SaveChangesAsync(cancellationToken);
                }
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return Result<TaskDTO>.Failure(ex.Message);
            }

            var workersListQuery =
                from teamMembers in _context.TeamMembers
                where (teamMembers.intTeamId == request.TaskDTO.intTeamId)
                select teamMembers.intWorkerId;

            List<int> workersList = await workersListQuery.ToListAsync();

            foreach (int workerId in workersList)
            {
                // send notifications to workers that task is activated
                try
                {
                    //Insert into Notifications Table

                    var username = await _context.Users
                        .Where(q => q.Id == workerId)
                        .Select(c => c.UserName)
                        .SingleOrDefaultAsync();

                    // Get Notification body and header
                    var notificationLayout = await _context.NotificationTypes
                        .Where(
                            q =>
                                q.intId
                                == (int)
                                    NotificationConstant.NotificationType.taskCreationNotification
                        )
                        .Select(
                            q =>
                                new NotificationLayout
                                {
                                    strHeaderAr = q.strHeaderAr,
                                    strBodyAr = q.strBodyAr,
                                    strBodyEn = q.strBodyEn,
                                    strHeaderEn = q.strHeaderEn
                                }
                        )
                        .SingleOrDefaultAsync();

                    if (notificationLayout == null)
                        throw new Exception("Notification Type table is empty");

                    string headerAr = notificationLayout.strHeaderAr;
                    string bodyAr =
                        notificationLayout.strBodyAr
                        + " "
                        + request.TaskDTO.deadlineDate.ToString()
                        + ". يرجى مراجعة تفاصيل المهمة وضمان الانتهاء في الوقت المحدد.";
                    string headerEn = notificationLayout.strHeaderEn;
                    string strBodyEn =
                        notificationLayout.strBodyEn
                        + " "
                        + request.TaskDTO.deadlineDate.ToString()
                        + ". Please review the task details and ensure timely completion";

                    await _mediator.Send(
                        new InsertNotificationCommand(
                            new Notification
                            {
                                intTypeId = (int)
                                    NotificationConstant.NotificationType.taskCreationNotification,
                                intUserId = workerId,
                                strHeaderAr = headerAr,
                                strBodyAr = bodyAr,
                                strHeaderEn = headerEn,
                                strBodyEn = strBodyEn,
                            }
                        )
                    );

                    //await _notificationService.SendNotification(workerId, headerAr, bodyAr);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                }
            }

            await transaction.CommitAsync();
            return Result<TaskDTO>.Success(taskDTO);
        }
    }
}
