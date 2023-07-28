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
using Application.Handlers.Tasks;
using Domain.ClientDTOs.Task;

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsIncompletedHandler
        : IRequestHandler<IncompleteTaskCommand, Result<IncompleteDTO>>
    {
        private readonly InsertTaskHandler _insertTaskHandler;
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;

        public SetTaskAsIncompletedHandler(
            InsertTaskHandler insertTaskHandler,
            DataContext context,
            UserManager<ApplicationUser> userManager
        )
        {
            _insertTaskHandler = insertTaskHandler;
            _context = context;
            _userManager = userManager;
        }

        public async Task<Result<IncompleteDTO>> Handle(
            IncompleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var taskDTO = new TaskDTO
            {
                strUserName = request.IncompleteDTO.strUserName,
                decCost = request.IncompleteDTO.taskDTO.decCost,
                scheduledDate = request.IncompleteDTO.taskDTO.scheduledDate,
                deadlineDate = request.IncompleteDTO.taskDTO.deadlineDate,
                strComment = request.IncompleteDTO.taskDTO.strComment,
                workersList = request.IncompleteDTO.taskDTO.workersList
            };
            var incompleteDTO = new IncompleteDTO
            {
                strComment = request.IncompleteDTO?.strComment,
                decRating = request.IncompleteDTO.decRating,
                taskDTO = taskDTO
            };

            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                task.intStatusId = (int)TasksConstant.taskStatus.incomplete;
                task.strComment = request.IncompleteDTO?.strComment;
                task.decRating = Convert.ToDecimal(request.IncompleteDTO.decRating);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update task status.");
            }

            try
            {
                int complaintId = await _context.TasksComplaints
                    .Where(q => q.intTaskId == request.Id)
                    .Select(q => q.intComplaintId)
                    .FirstOrDefaultAsync();

                var complaint = new Complaint { intId = complaintId };
                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;
                await _context.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync();
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update complaint status.");
            }

            var insertResult = await _insertTaskHandler.Handle(
                new InsertTaskCommand(taskDTO, request.Id),
                cancellationToken
            );

            return Result<IncompleteDTO>.Success(incompleteDTO);
        }
    }
}
