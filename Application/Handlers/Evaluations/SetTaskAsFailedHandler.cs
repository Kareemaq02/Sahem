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

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsFailedHandler : IRequestHandler<FailTaskCommand, Result<EvaluationDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;

        public SetTaskAsFailedHandler(DataContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        public async Task<Result<EvaluationDTO>> Handle(
            FailTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var failedDTO = new EvaluationDTO
            {
                strComment = request.FailedDTO?.strComment,
                decRating = request.FailedDTO.decRating
            };
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                task.intStatusId = (int)TasksConstant.taskStatus.failed;
                task.strComment = failedDTO?.strComment;
                task.decRating = Convert.ToDecimal(failedDTO.decRating);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<EvaluationDTO>.Failure("Failed to update task status.");
            }

            try
            {
                int complaintId = await _context.TasksComplaints
                    .Where(q => q.intTaskId == request.Id)
                    .Select(q => q.intComplaintId)
                    .FirstOrDefaultAsync();

                var complaint = new Complaint { intId = complaintId };
                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.approved;
                await _context.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync();
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<EvaluationDTO>.Failure("Failed to update complaint status.");
            }

            return Result<EvaluationDTO>.Success(failedDTO);
        }
    }
}
