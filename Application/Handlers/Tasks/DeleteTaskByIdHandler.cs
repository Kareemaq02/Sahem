using Application.Commands;
using Application.Core;
using Application.Services;
using Domain.DataModels.Complaints;
using Domain.DataModels.Notifications;
using Domain.DataModels.Tasks;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;
using System.Threading.Tasks;

namespace Application.Handlers
{
    public class DeleteTaskByIdHandler : IRequestHandler<DeleteTaskCommand, Result<Unit>>
    {
        private readonly DataContext _context;
        private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public DeleteTaskByIdHandler(
            DataContext context,
            AddComplaintStatusChangeTransactionHandler transactionHandler,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _context = context;
            _transactionHandler = transactionHandler;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<Unit>> Handle(
            DeleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            var TasksStatus = await _context.Tasks
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (TasksStatus != (int)TasksConstant.taskStatus.inactive)
                return Result<Unit>.Failure("Failed to delete the task.");
            try
            {
                var complaintIds = await _context.TasksComplaints
                    .Where(q => q.intTaskId == request.Id)
                    .Select(q => q.intComplaintId)
                    .ToListAsync();

                foreach (int complaintId in complaintIds)
                {
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.pending;
                    await _context.SaveChangesAsync(cancellationToken);

                    var complaintTransaction = await _context.ComplaintsStatuses
                        .Where(
                            c =>
                                c.intComplaintId == complaintId
                                && c.intStatusId != (int)ComplaintsConstant.complaintStatus.pending
                        )
                        .OrderBy(q => q.dtmTransDate)
                        .FirstOrDefaultAsync(cancellationToken);

                    if (complaintTransaction != null)
                        _context.ComplaintsStatuses.Remove(complaintTransaction);

                    await _context.SaveChangesAsync(cancellationToken);

                    try
                    {
                        //Insert into Notifications Table

                        var completedComplaintUserId = await _context.Complaints
                            .Where(q => q.intId == complaintId)
                            .Select(c => c.intUserID)
                            .SingleOrDefaultAsync();

                        var username = await _context.Users
                            .Where(q => q.Id == completedComplaintUserId)
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
                            + " إلى 'قيد الانتظار'. سيتم مراجعة شكوتك من قبل فريقنا وسنقوم بإعلامك بأي تحديثات جديدة. نشكرك على صبرك.";
                        string headerEn = notificationLayout.strHeaderEn;
                        string strBodyEn =
                            notificationLayout.strBodyEn
                            + " #"
                            + complaintId
                            + " has been updated to 'Pending' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.";

                        await _mediator.Send(
                            new InsertNotificationCommand(
                                new Notification
                                {
                                    intTypeId = (int)
                                        NotificationConstant
                                            .NotificationType
                                            .complaintStatusChangeNotification,
                                    intUserId = completedComplaintUserId,
                                    strHeaderAr = headerAr,
                                    strBodyAr = bodyAr,
                                    strHeaderEn = headerEn,
                                    strBodyEn = strBodyEn,
                                }
                            )
                        );

                        //await _notificationService.SendNotification(completedComplaintUserId, headerAr, bodyAr);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                    }
                }

                var workersListQuery =
                    from t in _context.Tasks
                    join team in _context.Teams on t.intTeamId equals team.intId
                    join teamMembers in _context.TeamMembers
                        on team.intId equals teamMembers.intTeamId
                    select teamMembers.intWorkerId;

                List<int> workersList = await workersListQuery.Distinct().ToListAsync();

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
                                        NotificationConstant
                                            .NotificationType
                                            .taskDeletionNotification
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
                        string bodyAr = notificationLayout.strBodyAr + " #" + request.Id + ".";
                        string headerEn = notificationLayout.strHeaderEn;
                        string strBodyEn =
                            notificationLayout.strBodyEn + " #" + request.Id + " has been deleted.";

                        await _mediator.Send(
                            new InsertNotificationCommand(
                                new Notification
                                {
                                    intTypeId = (int)
                                        NotificationConstant
                                            .NotificationType
                                            .taskDeletionNotification,
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
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete tasks.");
            }

            try
            {
                var taskComplaint = await _context.TasksComplaints
                    .Where(cc => cc.intTaskId == request.Id)
                    .ToListAsync(cancellationToken);

                _context.TasksComplaints.RemoveRange(taskComplaint);
                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete task.");
            }

            try
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                _context.Tasks.Remove(task);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete tasks.");
            }

            await transaction.CommitAsync();
            return Result<Unit>.Success(Unit.Value);
        }
    }
}
