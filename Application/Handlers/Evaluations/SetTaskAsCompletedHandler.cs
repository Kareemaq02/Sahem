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

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsCompletedHandler
        : IRequestHandler<CompleteTaskCommand, Result<EvaluationDTO>>
    {
        private readonly DataContext _context;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public SetTaskAsCompletedHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _changeTransactionHandler = changeTransactionHandler;
            _mediator = mediator;
            _notificationService = notificationService;
            _context = context;
            _userManager = userManager;
        }

        public async Task<Result<EvaluationDTO>> Handle(
            CompleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var completedDTO = new EvaluationDTO { decRating = request.CompletedDTO.decRating };

            var taskStatus = await _context.Tasks
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (taskStatus == (int)TasksConstant.taskStatus.waitingEvaluation)
            {
                using var transaction = await _context.Database.BeginTransactionAsync();

                try
                {
                    var task = new WorkTask { intId = request.Id };
                    _context.Tasks.Attach(task);
                    task.intStatusId = (int)TasksConstant.taskStatus.completed;
                    task.decRating = Convert.ToDecimal(completedDTO.decRating);

                    await _context.SaveChangesAsync(cancellationToken);
                }
                catch (DbUpdateException)
                {
                    await transaction.RollbackAsync();
                    return Result<EvaluationDTO>.Failure("Failed to update task status.");
                }

                try
                {
                    var complaintIds = await _context.TasksComplaints
                        .Where(q => q.intTaskId == request.Id)
                        .Select(q => q.intComplaintId)
                        .ToListAsync();

                    foreach (var x in complaintIds)
                    {
                        var complaint = new Complaint { intId = x };
                        _context.Complaints.Attach(complaint);
                        complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.completed;
                        await _context.SaveChangesAsync(cancellationToken);

                        await _changeTransactionHandler.Handle(
                            new AddComplaintStatusChangeTransactionCommand(
                                x,
                                (int)ComplaintsConstant.complaintStatus.completed
                            ),
                            cancellationToken
                        );
                        await _context.SaveChangesAsync(cancellationToken);

                        try
                        {
                            /* //Insert into Notifications Table
 
                             var completedComplaintUserId = await _context.Complaints
                                 .Where(q => q.intId == x).Select(c => c.intUserID).SingleOrDefaultAsync();
 
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
                             string bodyAr = notificationLayout.strBodyAr + " " + x;
                             string headerEn = notificationLayout.strHeaderEn;
                             string strBodyEn = notificationLayout.strBodyEn + " " + x + " has been completed.";
 
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
 
 
                             await _notificationService.SendNotification(completedComplaintUserId, headerAr, bodyAr);*/
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e.ToString());
                        }
                    }

                    await transaction.CommitAsync();
                }
                catch (DbUpdateException)
                {
                    await transaction.RollbackAsync();
                    return Result<EvaluationDTO>.Failure("Failed to update complaint status.");
                }
                return Result<EvaluationDTO>.Success(completedDTO);
            }
            else
                return Result<EvaluationDTO>.Failure(
                    "Only complaints with waiting evaluation status could be evaluated."
                );
        }
    }
}
