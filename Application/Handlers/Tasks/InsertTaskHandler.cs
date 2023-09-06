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
            var taskDTO = request.TaskDTO;
            int userId = await _context.Users
                .Where(q => q.UserName == taskDTO.strUserName)
                .Select(q => q.Id)
                .FirstOrDefaultAsync();

            
              var blnIsFromSameRegion = await _context.Complaints.
                    Where(q => request.TaskDTO.lstComplaintIds.Contains(q.intId))
                    .Select(q => q.intRegionId).Distinct().CountAsync() == 1;

              var blnHasCorrectStatus = await _context.Complaints.
                    Where(q => request.TaskDTO.lstComplaintIds.Contains(q.intId)
                    && (q.intStatusId == (int)ComplaintsConstant.complaintStatus.refiled
                    || q.intStatusId == (int)ComplaintsConstant.complaintStatus.pending))
                    .Select(q => q.intId).CountAsync() == request.TaskDTO.lstComplaintIds.Count();

            if (blnHasCorrectStatus == false)
                return Result<TaskDTO>.Failure("Tasks could only be created for pending or refiled complaints.");

            if (blnIsFromSameRegion == false)
                return Result<TaskDTO>.Failure("Not all selected complaints are within the same region.");

            try
            {
                //Tasks table
                var task = new WorkTask //Date Activated and Date Finished should be null
                {
                    intAdminId = userId,
                    intStatusId = (int)TasksConstant.taskStatus.inactive,
                    intTypeId = request.TaskDTO.intTaskType,
                    decCost = request.TaskDTO.decCost ?? 0.00m,
                    dtmDateScheduled = request.TaskDTO.scheduledDate,
                    dtmDateDeadline = request.TaskDTO.deadlineDate,
                    intLastModifiedBy = userId,
                    strComment = request.TaskDTO.strComment,
                    dtmDateLastModified = DateTime.Now,
                    decRating = 0,
                    intTeamId = request.TaskDTO.intTeamId,
                    blnIsDeleted = false
                };
                var taskEntity = await _context.Tasks.AddAsync(task);
                await _context.SaveChangesAsync(cancellationToken);

                if (request.TaskDTO.lstComplaintIds.Count == 0)
                    return Result<TaskDTO>.Failure("Choose complaint(s)");
                    //TaskComplaints table

                    foreach (int complaintId in request.TaskDTO.lstComplaintIds)
                {
                    var taskComplaint = new WorkTaskComplaints
                    {
                        intTaskId = taskEntity.Entity.intId,
                        intComplaintId = complaintId
                    };

                    await _context.TasksComplaints.AddAsync(taskComplaint);
                }

                //Complaints Table
                foreach (int complaintId in request.TaskDTO.lstComplaintIds)
                {
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;
                    await _context.SaveChangesAsync(cancellationToken);

                    //Complaints_statuses Table
                    await _transactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                            complaintId,
                            (int)ComplaintsConstant.complaintStatus.Scheduled
                        ),
                        cancellationToken
                    );

                    await _context.SaveChangesAsync(cancellationToken);
                }
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
