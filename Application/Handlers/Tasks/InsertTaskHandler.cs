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

namespace Application.Handlers.Tasks
{
    public class InsertTaskHandler : IRequestHandler<InsertTaskCommand, Result<TaskDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;
        public readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

        public InsertTaskHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler transactionHandler
        )
        {
            _context = context;
            _userManager = userManager;
            _transactionHandler = transactionHandler;
        }

        public async Task<Result<TaskDTO>> Handle(
            InsertTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            var leaderCount = 0;
            var taskDTO = request.TaskDTO;
            var workersList = taskDTO.workersList;
            int userId = await _context.Users
                .Where(q => q.UserName == taskDTO.strUserName)
                .Select(q => q.Id)
                .FirstOrDefaultAsync();
            int taskType = await _context.Complaints
                .Where(q => q.intId == request.Id)
                .Select(q => q.intTypeId)
                .FirstOrDefaultAsync();

            try
            {
                var task = new WorkTask //Date Activated and Date Finished should be null
                {
                    intAdminId = userId,
                    intStatusId = (int)TasksConstant.taskStatus.inactive,
                    intTypeId = taskType,
                    decCost = request.TaskDTO.decCost ?? 0.00m,
                    dtmDateScheduled = request.TaskDTO.scheduledDate,
                    dtmDateDeadline = request.TaskDTO.deadlineDate,
                    intLastModifiedBy = userId,
                    strComment = request.TaskDTO.strComment,
                    dtmDateLastModified = DateTime.Now,
                    decRating = 0,
                    blnIsDeleted = false
                };
                var taskEntity = await _context.Tasks.AddAsync(task);
                await _context.SaveChangesAsync(cancellationToken);

                try
                {
                    if (workersList == null || workersList.Count == 0)
                    {
                        await transaction.RollbackAsync();
                        return Result<TaskDTO>.Failure("No Members were added");
                    }
                    int i = 0;
                    foreach (var worker in workersList)
                    {
                        var user2 = await _context.Users.FindAsync(worker.intId);
                        if (user2 == null)
                        {
                            await transaction.RollbackAsync();
                            return Result<TaskDTO>.Failure($"Invalid user id: {worker.intId}");
                        }

                        if (user2.intUserTypeId != (int)UsersConstant.userTypes.worker)
                        {
                            await transaction.RollbackAsync();
                            return Result<TaskDTO>.Failure($"Invalid worker id: {worker.intId}");
                        }

                        var workerNameQuery =
                            from user in _context.UserInfos
                            where user.intId == worker.intId
                            select new { user.strFirstName, user.strLastName };
                        var workerUser = await workerNameQuery.FirstOrDefaultAsync();

                        taskDTO.workersList.ElementAt(i).strFirstName = workerUser.strFirstName;
                        taskDTO.workersList.ElementAt(i).strLastName = workerUser.strLastName;
                        i++;
                        var taskWorker = new TeamMembers
                        {
                            intWorkerId = worker.intId,
                            intTeamId = taskEntity.Entity.intId,
                            blnIsLeader = worker.isLeader
                        };

                        await _context.TeamMembers.AddAsync(taskWorker);

                        if (worker.isLeader)
                            leaderCount++;
                    }

                    if (leaderCount == 0)
                    {
                        await transaction.RollbackAsync();
                        return Result<TaskDTO>.Failure("No leader was selected");
                    }
                    if (leaderCount > 1)
                    {
                        await transaction.RollbackAsync();
                        return Result<TaskDTO>.Failure("More than one leader was selected");
                    }

                    var taskComplaint = new WorkTaskComplaints
                    {
                        intTaskId = taskEntity.Entity.intId,
                        intComplaintId = request.Id
                    };

                    await _context.TasksComplaints.AddAsync(taskComplaint);

                    var complaint = new Complaint { intId = request.Id };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;
                    await _context.SaveChangesAsync(cancellationToken);

                    await _transactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                            request.Id,
                            (int)ComplaintsConstant.complaintStatus.Scheduled
                        ),
                        cancellationToken
                    );
                    await _context.SaveChangesAsync(cancellationToken);
                }
                catch (Exception)
                {
                    await transaction.RollbackAsync();
                    return Result<TaskDTO>.Failure("Unknown Error");
                }

                await _context.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync();
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return Result<TaskDTO>.Failure(ex.Message);
            }

            return Result<TaskDTO>.Success(taskDTO);
        }
    }
}
