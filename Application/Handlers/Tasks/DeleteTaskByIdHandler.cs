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

        public DeleteTaskByIdHandler(DataContext context,
            AddComplaintStatusChangeTransactionHandler transactionHandler,
            IMediator mediator, NotificationService notificationService)
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



            var complaintIds = await _context.TasksComplaints
                  .Where(q => q.intTaskId == request.Id)
                  .Select(q => q.intComplaintId)
                  .ToListAsync();

            List<int> userIds = new List<int>();

            foreach (int complaintId in complaintIds)
            {
  
                var complaint = await _context.Complaints
                                .Where(q => q.intId == complaintId)
                                .Select(q => new Complaint
                                {
                                    intId = q.intId,
                                    intUserID = q.intUserID,
                                    intStatusId = q.intStatusId
                                }).SingleOrDefaultAsync();

                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.pending;
                await _context.SaveChangesAsync(cancellationToken);

                var complaintTransaction = await _context.ComplaintsStatuses
                                   .Where(c => c.intComplaintId == complaintId && c.intStatusId
                                   != (int)ComplaintsConstant.complaintStatus.pending)
                                   .OrderBy(q => q.dtmTransDate)
                                   .FirstOrDefaultAsync(cancellationToken);

                if (complaintTransaction != null)
                    _context.ComplaintsStatuses.Remove(complaintTransaction);

                userIds.Add(complaint.intUserID);

                await _context.SaveChangesAsync(cancellationToken);
            }


            try
            {

                // Get Notification body and header
                var notificationLayout = await _context.NotificationTypes
                   .Where(q => q.intId == (int)NotificationConstant.NotificationType.pendingComplaintNotification)
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
                string bodyAr = notificationLayout.strBodyAr;
                string headerEn = notificationLayout.strHeaderEn;
                string strBodyEn = notificationLayout.strBodyEn;

                foreach (int userID in userIds)
                {
                    await _mediator.
                        Send(new InsertNotificationCommand(new Notification
                        {
                            intTypeId = (int)NotificationConstant.NotificationType.pendingComplaintNotification,
                            intUserId = userID,

                            strHeaderAr = headerAr,
                            strBodyAr = bodyAr,

                            strHeaderEn = headerEn,
                            strBodyEn = strBodyEn,
                        }));
                }

                _notificationService.SendNotifications(userIds, headerAr, bodyAr);
            }
            catch
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to send notification");

            }



            var workersListQuery =
                from t in _context.Tasks
                join team in _context.Teams on t.intTeamId equals team.intId
                join teamMembers in _context.TeamMembers on team.intId equals teamMembers.intTeamId
                select teamMembers.intWorkerId;


            List<int> workersList = await workersListQuery.Distinct().ToListAsync();

            try
            {

                // Get Notification body and header
                var notificationLayout = await _context.NotificationTypes
                   .Where(q => q.intId == (int)NotificationConstant.NotificationType.taskDeletionNotification)
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
                string bodyAr = notificationLayout.strBodyAr + $" #{request.Id}";

                string headerEn = notificationLayout.strHeaderEn;
                string strBodyEn = notificationLayout.strBodyEn + $" #{request.Id} has been deleted";

                foreach (int workerID in workersList)
                {
                    await _mediator.
                        Send(new InsertNotificationCommand(new Notification
                        {
                            intTypeId = (int)NotificationConstant.NotificationType.taskDeletionNotification,
                            intUserId = workerID,

                            strHeaderAr = headerAr,
                            strBodyAr = bodyAr,

                            strHeaderEn = headerEn,
                            strBodyEn = strBodyEn,
                        }));
                }

                _notificationService.SendNotifications(workersList, headerAr, bodyAr);
            }
            catch
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to send notification");

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
