using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Complaints;
using Application.Services;
using Domain.DataModels.Notifications;
using Domain.Helpers;

public class ActivateTaskByIdHandler : IRequestHandler<ActivateTaskCommand, Result<Unit>>
{
    private readonly DataContext _context;
    private readonly AddComplaintStatusChangeTransactionHandler _addTransactionHandler;
    public readonly UserManager<ApplicationUser> _userManager;
    private readonly IMediator _mediator;
    private readonly NotificationService _notificationService;

    public ActivateTaskByIdHandler(
        DataContext context,
        AddComplaintStatusChangeTransactionHandler addTransactionHandler,
        UserManager<ApplicationUser> userManager,
        IMediator mediator,
        NotificationService notificationService
    )
    {
        _addTransactionHandler = addTransactionHandler;
        _context = context;
        _userManager = userManager;
        _mediator = mediator;
        _notificationService = notificationService;
    }

    public async Task<Result<Unit>> Handle(
        ActivateTaskCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var isLeader = _context.Teams.Any(tm => tm.intLeaderId == userId); //Assuming a leader cant be a worker in another team

        //Start transaction
        using var transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
        try
        {
            if (isLeader)
            {
                var task = await _context.Tasks.FindAsync(request.Id);

                var activeTasksCount = from t in _context.Tasks
                                       join team in _context.Teams on t.intTeamId equals team.intId
                                       where team.intLeaderId == userId && t.intStatusId == (int)TasksConstant.taskStatus.inProgress
                                       select t;


                if (await activeTasksCount.CountAsync() >= 1)
                    return Result<Unit>.Failure("Please submit previously activated tasks before activating this one");

                if (task.blnIsActivated == false)
                {
                    if (task.intStatusId == (int)TasksConstant.taskStatus.inactive)
                    {
                        task.dtmDateActivated = DateTime.UtcNow;
                        task.blnIsActivated = true;
                        task.dtmDateLastModified = DateTime.UtcNow;
                        task.intLastModifiedBy = userId;
                        task.intStatusId = (int)TasksConstant.taskStatus.inProgress;

                        await _context.SaveChangesAsync(cancellationToken);

                        var complaintIds = await _context.TasksComplaints
                            .Where(q => q.intTaskId == request.Id)
                            .Select(q => q.intComplaintId)
                            .ToListAsync();

                        List<int> userIds = new List<int>();
                        foreach (int complaintId in complaintIds)
                        {
                            var complaint = await _context.Complaints
                                .Where(q => q.intId == complaintId)
                                .Select(q => new Complaint { intId = q.intId,
                                    intUserID = q.intUserID,
                                    intStatusId = q.intStatusId }).SingleOrDefaultAsync();

                            _context.Complaints.Attach(complaint);

                            complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.inProgress;
                            await _context.SaveChangesAsync(cancellationToken);

                            await _addTransactionHandler.Handle(
                                new AddComplaintStatusChangeTransactionCommand(
                                    complaintId,
                                    (int)ComplaintsConstant.complaintStatus.inProgress
                                ),
                                cancellationToken
                            );
                            userIds.Add(complaint.intUserID);
                            await _context.SaveChangesAsync(cancellationToken);
                        }
                        try
                        {

                            // Get Notification body and header
                            var notificationLayout = await _context.NotificationTypes
                               .Where(q => q.intId == (int)NotificationConstant.NotificationType.inProgressComplaintNotification)
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
                                        intTypeId = (int)NotificationConstant.NotificationType.inProgressComplaintNotification,
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


                        var workersListQuery = from t in _context.Tasks
                                               join team in _context.Teams on t.intTeamId equals team.intId
                                               join teamMembers in _context.TeamMembers on team.intId equals teamMembers.intTeamId
                                               select teamMembers.intWorkerId;

                        List<int> workersList = await workersListQuery.Distinct().ToListAsync();

                        try
                        {

                            // Get Notification body and header
                            var notificationLayout = await _context.NotificationTypes
                               .Where(q => q.intId == (int)NotificationConstant.NotificationType.activeTaskNotification)
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
                            string strBodyEn = notificationLayout.strBodyEn + $" #{request.Id} has been activated";

                            foreach (int workerID in workersList)
                            {
                                await _mediator.
                                    Send(new InsertNotificationCommand(new Notification
                                    {
                                        intTypeId = (int)NotificationConstant.NotificationType.activeTaskNotification,
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



                        await transaction.CommitAsync();
                        return Result<Unit>.Success(Unit.Value);
                    }
                    else
                        return Result<Unit>.Failure("Only inactive tasks could be activated");
                }
                else
                    return Result<Unit>.Failure("Task has already been activated");
            }
            else
                return Result<Unit>.Failure("Only the leader is allowed to activate the task");
        }
        catch
        {
            await transaction.RollbackAsync();
            return Result<Unit>.Failure("Task activation failed");
        }
    }
}
