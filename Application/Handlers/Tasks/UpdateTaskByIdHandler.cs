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
                    var AvailableTeamsIdsQuery =
                        from teams in _context.Teams
                        join t in _context.Tasks on teams.intId equals t.intTeamId
                        where (
                               (t.dtmDateDeadline > request.updateTaskDTO.deadlineDate && t.dtmDateScheduled > request.updateTaskDTO.deadlineDate)
                                || (t.dtmDateDeadline < request.updateTaskDTO.scheduledDate && t.dtmDateScheduled < request.updateTaskDTO.scheduledDate)
                                )
                        select teams.intId;

                                 if (!await (AvailableTeamsIdsQuery.ContainsAsync(request.updateTaskDTO.intTeamId)))
                                 return Result<UpdateTaskDTO>.Failure("Team is not available at chosen dates");
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

        await _context.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync();

        return Result<UpdateTaskDTO>.Success(UpdateTaskDTO);
    }
}
