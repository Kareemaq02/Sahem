using Application.Core;
using Domain.DataModels.Tasks;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.Resources;
using Domain.DataModels.Complaints;
using Domain.ClientDTOs.Evaluation;
using Application.Commands;
using Application.Services;
using Domain.DataModels.Notifications;
using Domain.Helpers;
using Application.Queries.Users;

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsIncompletedHandler
        : IRequestHandler<IncompleteTaskCommand, Result<IncompleteDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public SetTaskAsIncompletedHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _context = context;
            _userManager = userManager;
            _changeTransactionHandler = changeTransactionHandler;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<IncompleteDTO>> Handle(
            IncompleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var incompleteDTO = new IncompleteDTO
            {

                strComment = request.IncompleteDTO?.strComment,
                decRating = request.IncompleteDTO.decRating,
                lstCompletedIds = request.IncompleteDTO.lstCompletedIds,
                lstFailedIds = request.IncompleteDTO.lstFailedIds,
                decCost = request.IncompleteDTO.decCost,
                dtmNewDeadline = request.IncompleteDTO.dtmNewDeadline,
                dtmNewScheduled = request.IncompleteDTO.dtmNewScheduled,
                intNewTaskTypeId = request.IncompleteDTO.intNewTaskTypeId

            };

            using var transaction = await _context.Database.BeginTransactionAsync();

            var task = await _context.Tasks.Where(q => q.intId == request.Id).FirstOrDefaultAsync();

            var userId = await _context.Users
                    .Where(u => u.UserName == request.IncompleteDTO.strUserName)
                    .Select(u => u.Id)
                    .SingleOrDefaultAsync(cancellationToken: cancellationToken);


            //Check if team is available in new dates
            var teamAvailabilityResult = await _mediator.Send(new CheckIfTeamIsAvailableByIdQuery(
                        startDate: request.IncompleteDTO.dtmNewScheduled,
                          endDate: request.IncompleteDTO.dtmNewDeadline,
                           intTeamId: task.intTeamId
                        ));


            if (teamAvailabilityResult.Value == false)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Team is not avaialable in those dates");
            }




            try
            {
                // Updates old task status and rating
                task.intStatusId = (int)TasksConstant.taskStatus.incomplete;
                task.decRating = Convert.ToDecimal(request.IncompleteDTO.decRating);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException e)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update task status." + e);
            }

            try
            {

                foreach (int complaintId in request.IncompleteDTO.lstCompletedIds)
                {
                    //completed
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.completed;
                    await _context.SaveChangesAsync(cancellationToken);

                    await _changeTransactionHandler.Handle(
                         new AddComplaintStatusChangeTransactionCommand(
                                 complaintId,
                                 (int)ComplaintsConstant.complaintStatus.completed
                             ),
                                 cancellationToken
                             );
                    

                   /* try
                    {
                        //Insert into Notifications Table

                        var completedComplaintUserId = await _context.Complaints
                            .Where(q => q.intId == complaintId).Select(c => c.intUserID).SingleOrDefaultAsync();

                        var username = await _context.Users.
                            Where(q => q.Id == completedComplaintUserId).Select(c => c.UserName).SingleOrDefaultAsync();

                        // Get Notification body and header
                        var notificationLayout = await _context.NotificationTypes
                           .Where(q => q.intId == (int)NotificationConstant.NotificationType.completedComplaintNotification)
                           .Select(q => new NotificationLayout
                           {
                               strHeaderAr = q.strHeaderAr,
                               strBodyAr = q.strBodyAr,
                               strBodyEn = q.strBodyEn,
                               strHeaderEn = q.strHeaderEn
                           }).SingleOrDefaultAsync();

                        if (notificationLayout == null)
                            throw new Exception("Notification Type table is empty");

                        string headerAr = notificationLayout.strHeaderAr;
                        string bodyAr = notificationLayout.strBodyAr + " " + complaintId;
                        string headerEn = notificationLayout.strHeaderEn;
                        string strBodyEn = notificationLayout.strBodyEn + " " + complaintId + " has been completed.";

                        await _mediator.
                            Send(new InsertNotificationCommand(new Notification
                            {
                                intTypeId = (int)NotificationConstant.NotificationType.completedComplaintNotification,
                                intUserId = completedComplaintUserId,

                                strHeaderAr = headerAr,
                                strBodyAr = bodyAr,

                                strHeaderEn = headerEn,
                                strBodyEn = strBodyEn,
                            }));


                        await _notificationService.SendNotification(completedComplaintUserId, headerAr, bodyAr);
                    }
                    catch (Exception e)
                    {
                        await transaction.RollbackAsync();
                        Console.WriteLine(e.ToString());
                    }*/

                }
                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException e)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update complaint status." + e);
            }
            try
            {


                var newTask = await _context.Tasks.AddAsync(new WorkTask
                {

                    intAdminId = userId,
                    strComment = request.IncompleteDTO?.strComment,
                    dtmDateScheduled = request.IncompleteDTO.dtmNewScheduled,
                    dtmDateDeadline = request.IncompleteDTO.dtmNewDeadline,
                    blnIsActivated = false,
                    intStatusId = (int)TasksConstant.taskStatus.inactive,
                    intTeamId = task.intTeamId,
                    intTypeId = request.IncompleteDTO.intNewTaskTypeId,
                    blnIsDeleted = false,
                    intLastModifiedBy = userId,
                    dtmDateCreated = DateTime.UtcNow,

                });

                await _context.SaveChangesAsync(cancellationToken);




                foreach (int complaintId in request.IncompleteDTO.lstFailedIds)
                {
                    //failed
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;
                    await _context.SaveChangesAsync(cancellationToken);

                    var complaintTransaction = await _context.ComplaintsStatuses
                                      .Where(c => c.intComplaintId == complaintId && c.intStatusId
                                      != (int)ComplaintsConstant.complaintStatus.Scheduled)
                                      .OrderBy(q => q.dtmTransDate)
                                      .FirstOrDefaultAsync(cancellationToken);

                    if(complaintTransaction!=null)
                    _context.ComplaintsStatuses.Remove(complaintTransaction);

                    await _context.SaveChangesAsync(cancellationToken);

                    await _changeTransactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                                complaintId,
                                (int)ComplaintsConstant.complaintStatus.Scheduled
                            ),
                                cancellationToken
                            );
                    await _context.SaveChangesAsync(cancellationToken);

                    try
                    {
                        // Insert into TaskComplaints Table
                        await _context.TasksComplaints.AddAsync(new Domain.DataModels.Intersections.WorkTaskComplaints
                        {
                            intTaskId = newTask.Entity.intId,
                            intComplaintId = complaintId,
                        });

                        await _context.SaveChangesAsync();

                        // Insert into Notifications Table

                        /*var completedComplaintUserId = await _context.Complaints
                            .Where(q => q.intId == complaintId).Select(c => c.intUserID).SingleOrDefaultAsync();

                        var username = await _context.Users.
                            Where(q => q.Id == completedComplaintUserId).Select(c => c.UserName).SingleOrDefaultAsync();

                        // Get Notification body and header
                        var notificationLayout = await _context.NotificationTypes
                           .Where(q => q.intId == (int)NotificationConstant.NotificationType.complaintStatusChangeNotification)
                           .Select(q => new NotificationLayout
                           {
                               strHeaderAr = q.strHeaderAr,
                               strBodyAr = q.strBodyAr,
                               strBodyEn = q.strBodyEn,
                               strHeaderEn = q.strHeaderEn
                           }).SingleOrDefaultAsync();

                        if (notificationLayout == null)
                            throw new Exception("Notification Type table is empty");

                        string headerAr = notificationLayout.strHeaderAr;
                        string bodyAr = notificationLayout.strBodyAr + " #" + complaintId + " إلى 'قيد الانتظار'. سيتم مراجعة شكوتك من قبل فريقنا وسنقوم بإعلامك بأي تحديثات جديدة. نشكرك على صبرك.";
                        string headerEn = notificationLayout.strHeaderEn;
                        string strBodyEn = notificationLayout.strBodyEn + " #" + complaintId + " has been updated to 'Pending' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.";

                        await _mediator.
                            Send(new InsertNotificationCommand(new Notification
                            {
                                intTypeId = (int)NotificationConstant.NotificationType.complaintStatusChangeNotification,
                                intUserId = completedComplaintUserId,

                                strHeaderAr = headerAr,
                                strBodyAr = bodyAr,

                                strHeaderEn = headerEn,
                                strBodyEn = strBodyEn,
                            }));


                        await _notificationService.SendNotification(completedComplaintUserId, headerAr, bodyAr);*//**/
                    }
                    catch (Exception e)
                    {
                        await transaction.RollbackAsync();
                        return Result<IncompleteDTO>.Failure("Failed to update complaint status." + e);
                    }
                }

            }
            catch (DbUpdateException e )
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update complaint status." + e);
            }

          
            await transaction.CommitAsync();
            return Result<IncompleteDTO>.Success(incompleteDTO);
        }
    }
}
