using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Tasks;
using Domain.DataModels.Intersections;
using Domain.ClientDTOs.Task;

public class UpdateTaskByIdHandler : IRequestHandler<UpdateTaskCommand, Result<UpdateTaskDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public UpdateTaskByIdHandler(
        DataContext context,
        IConfiguration configuration,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
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

        /*    var newTaskStartDate = request.updateTaskDTO.scheduledDate;
            var newTaskDeadlineDate = request.updateTaskDTO.deadlineDate;
            var newTaskComment = request.updateTaskDTO.strComment;
            var newWorkersList = request.updateTaskDTO.workersList;
            var newTaskTypeId = request.updateTaskDTO.intTaskTypeId;*/

        var UpdateTaskDTO = new UpdateTaskDTO { };

        // transaction start...
        using var transaction = await _context.Database.BeginTransactionAsync();
        var leaderCount = 0;
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

                if (request.updateTaskDTO.scheduledDate != DateTime.MinValue)
                {
                    task.dtmDateScheduled = request.updateTaskDTO.scheduledDate;
                    UpdateTaskDTO.scheduledDate = request.updateTaskDTO.scheduledDate;
                    ;
                }

                await _context.SaveChangesAsync(cancellationToken);
            }
            else
            {
                return Result<UpdateTaskDTO>.Failure("Failed to update the task.");
            }
        }
        catch (DbUpdateException)
        {
            return Result<UpdateTaskDTO>.Failure("Failed to update task.");
        }

        try
        {
            if (
                request.updateTaskDTO.workersList != null
                && request.updateTaskDTO.workersList.Count != 0
            )
            {
                var oldWorkersList = await _context.TaskMembers
                    .Where(tm => tm.intTaskId == request.Id)
                    .ToListAsync();

                _context.TaskMembers.RemoveRange(oldWorkersList);
                UpdateTaskDTO.workersList = request.updateTaskDTO.workersList;
                foreach (var worker in request.updateTaskDTO.workersList)
                {
                    var user2 = await _context.Users.FindAsync(worker.intId);
                    if (user2 == null)
                    {
                        await transaction.RollbackAsync();
                        return Result<UpdateTaskDTO>.Failure($"Invalid user id: {worker.intId}");
                    }

                    var taskWorker = new WorkTaskMembers
                    {
                        intWorkerId = worker.intId,
                        intTaskId = request.Id,
                        blnIsLeader = worker.isLeader
                    };

                    await _context.TaskMembers.AddAsync(taskWorker);

                    if (worker.isLeader)
                    {
                        leaderCount++;
                    }
                }

                if (leaderCount == 0)
                {
                    await transaction.RollbackAsync();
                    return Result<UpdateTaskDTO>.Failure("No leader was selected");
                }

                if (leaderCount > 1)
                {
                    await transaction.RollbackAsync();
                    return Result<UpdateTaskDTO>.Failure("More than one leader was selected");
                }
            }
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            return Result<UpdateTaskDTO>.Failure("Unknown Error");
        }

        await _context.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync();

        return Result<UpdateTaskDTO>.Success(UpdateTaskDTO);
    }
}
