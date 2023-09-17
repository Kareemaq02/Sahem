using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Tasks;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Notifications;
using Application.Services;
using System.Globalization;
using Application.Queries.Users;

public class UpdateTaskByIdHandler : IRequestHandler<UpdateTaskCommand, Result<UpdateTaskDTO>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;
    private readonly IMediator _mediator;
    private readonly NotificationService _notificationService;

    public UpdateTaskByIdHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager,
        IMediator mediator,
        NotificationService notificationService
    )
    {
        _context = context;
        _userManager = userManager;
        _mediator = mediator;
        _notificationService = notificationService;
    }

    public async Task<Result<UpdateTaskDTO>> Handle(
        UpdateTaskCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.updateTaskDTO.strUserName)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);


        var UpdateTaskDTO = new UpdateTaskDTO { };

        // transaction start...
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var taskStatus = await _context.Tasks
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (
                taskStatus != (int)TasksConstant.taskStatus.waitingEvaluation
                && taskStatus != (int)TasksConstant.taskStatus.completed
            )
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);

                if (request.updateTaskDTO.intTaskTypeId != 0)
                {
                    task.intTypeId = request.updateTaskDTO.intTaskTypeId;
                    UpdateTaskDTO.intTaskTypeId = request.updateTaskDTO.intTaskTypeId;
                }

                if (!string.IsNullOrWhiteSpace(request.updateTaskDTO.strComment))
                {
                    task.strComment = request.updateTaskDTO.strComment;
                    UpdateTaskDTO.strComment = request.updateTaskDTO.strComment;
                }

                task.intLastModifiedBy = (int)userId;

                if (request.updateTaskDTO.deadlineDate != DateTime.MinValue)
                {
                    task.dtmDateDeadline = request.updateTaskDTO.deadlineDate;
                    UpdateTaskDTO.deadlineDate = request.updateTaskDTO.deadlineDate;
                }
                else
                {
                    UpdateTaskDTO.deadlineDate = task.dtmDateDeadline;
                }

                if (request.updateTaskDTO.scheduledDate != DateTime.MinValue)
                {
                    task.dtmDateScheduled = request.updateTaskDTO.scheduledDate;
                    UpdateTaskDTO.scheduledDate = request.updateTaskDTO.scheduledDate;
                    ;
                }
                else
                {
                    UpdateTaskDTO.scheduledDate = task.dtmDateScheduled;
                }

                if (request.updateTaskDTO.intTeamId != 0)
                {
                    task.intTeamId = request.updateTaskDTO.intTeamId;
                    UpdateTaskDTO.intTeamId = request.updateTaskDTO.intTeamId;
                }
                else {
                    var teamAvailabilityResult = await _mediator.Send(new CheckIfTeamIsAvailableByIdQuery(
                        startDate: request.updateTaskDTO.scheduledDate,
                          endDate: request.updateTaskDTO.deadlineDate,
                           intTeamId: task.intTeamId
                        ));
                }

                await _context.SaveChangesAsync(cancellationToken);
            }
            else
            {
                await transaction.RollbackAsync(cancellationToken);
                return Result<UpdateTaskDTO>.Failure("Failed to update the task.");
            }
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync(cancellationToken);
            return Result<UpdateTaskDTO>.Failure("Failed to update task.");
        }


 


    /*    string updateNotificationEn = $"Task Id: {request.Id}\n"+$"Scheduled Date: {UpdateTaskDTO.scheduledDate}" +
            $"\n Deadline Date: {UpdateTaskDTO.deadlineDate}\n Comment: {UpdateTaskDTO.strComment}" +
            $" \n Team Number: {UpdateTaskDTO.intTeamId}\n";

        string updateNotificationAr = $"رقم المهمة: {request.Id}\nتاريخ الجدولة: {UpdateTaskDTO.scheduledDate.ToString("dd/MM/yyyy hh:mm:ss tt")}" +
             $"\nتاريخ الاستحقاق: {UpdateTaskDTO.deadlineDate.ToString("dd/MM/yyyy hh:mm:ss tt")}\nالتعليق: {UpdateTaskDTO.strComment}" +
             $" \nرقم الفريق: {UpdateTaskDTO.intTeamId}\n";

        

        var workersListQuery = from t in _context.Tasks
                               join team in _context.Teams on t.intTeamId equals team.intId
                               join teamMembers in _context.TeamMembers on team.intId equals teamMembers.intTeamId
                               where(t.intId == request.Id)
                               select teamMembers.intWorkerId;

        List<int> workersList = await workersListQuery.Distinct().ToListAsync();

        foreach (int workerId in workersList)
        {
            // send notifications to workers that task is activated
            try
            {
                //Insert into Notifications Table

                var username = await _context.Users.
                    Where(q => q.Id == workerId).Select(c => c.UserName).SingleOrDefaultAsync();

     


                string headerAr = "تم تحديث إحدى مهامك.";
                string bodyAr = updateNotificationAr;
                string headerEn = "One of your tasks has been updated.";
                string strBodyEn = updateNotificationEn;
                await _mediator.
                    Send(new InsertNotificationCommand(new Notification
                    {
                        intTypeId = 8,
                        intUserId = workerId,

                        strHeaderAr = headerAr,
                        strBodyAr = bodyAr,

                        strHeaderEn = headerEn,
                        strBodyEn = strBodyEn,
                    }));


                await _notificationService.SendNotification(workerId, headerAr, bodyAr);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

        }*/

        await _context.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync();

        return Result<UpdateTaskDTO>.Success(UpdateTaskDTO);
    }
}
