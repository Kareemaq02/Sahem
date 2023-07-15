using Application.Core;
using Application;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.ClientDTOs.User;
using Org.BouncyCastle.Asn1.Ocsp;
using Domain.Resources;
using Domain.DataModels.Tasks;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Intersections;
using Application.Handlers.Tasks;

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

    public async Task<Result<UpdateTaskDTO>> Handle(UpdateTaskCommand request, CancellationToken cancellationToken)
    {
        var userId = await _context.Users
               .Where(u => u.UserName == request.updateTaskDTO.strUserName)
               .Select(u => u.Id)
               .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var newTaskStartDate = request.updateTaskDTO.scheduledDate;
        var newTaskDeadlineDate = request.updateTaskDTO.deadlineDate;
        var newTaskComment = request.updateTaskDTO.strComment;
        var newWorkersList = request.updateTaskDTO.workersList;
        var newTaskTypeEn = request.updateTaskDTO.strTaskTypeEng;

        var UpdateTaskDTO = new UpdateTaskDTO
        {
            strComment = newTaskComment,
            scheduledDate = newTaskStartDate,
            deadlineDate = newTaskDeadlineDate,
            workersList = newWorkersList,
            strTaskTypeEng = newTaskTypeEn
        };

        // transaction start...
        using var transaction = await _context.Database.BeginTransactionAsync();
        var leaderCount = 0;
        try
        {
            var taskStatus = await _context.Tasks
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (taskStatus != (int)TasksConstant.taskStatus.waitingEvaluation && taskStatus != (int)TasksConstant.taskStatus.completed)
            {
                var taskTypeId = await _context.TaskTypes
                .Where(c => c.strNameEn == request.updateTaskDTO.strTaskTypeEng)
                .Select(c => c.intId)
                .FirstOrDefaultAsync(cancellationToken);

                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                task.strComment = newTaskComment;
                task.intLastModifiedBy = (int)userId;
                task.intTypeId = taskTypeId;
                task.dtmDateDeadline = newTaskDeadlineDate;
                task.dtmDateScheduled = newTaskStartDate;
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
            {
                return Result<UpdateTaskDTO>.Failure("Failed to update the complaint.");
            }
        }
        catch (DbUpdateException)
        {
            return Result<UpdateTaskDTO>.Failure("Failed to update complaint.");
        }

        try
        {

            var oldWorkersList = await _context.TaskMembers
            .Where(tm => tm.intTaskId == request.Id)
            .ToListAsync();

            _context.TaskMembers.RemoveRange(oldWorkersList);


            if (newWorkersList == null || newWorkersList.Count == 0)
            {
                await transaction.RollbackAsync();
                return Result<UpdateTaskDTO>.Failure("No Members were added");
            }

            foreach (var worker in newWorkersList)
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