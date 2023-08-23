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

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsCompletedHandler
        : IRequestHandler<CompleteTaskCommand, Result<EvaluationDTO>>
    {
        private readonly DataContext _context;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;
        public readonly UserManager<ApplicationUser> _userManager;

        public SetTaskAsCompletedHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler
        )
        {
            _changeTransactionHandler = changeTransactionHandler;
            _context = context;
            _userManager = userManager;
        }

        public async Task<Result<EvaluationDTO>> Handle(
            CompleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var completedDTO = new EvaluationDTO
            {
                strComment = request.CompletedDTO?.strComment,
                decRating = request.CompletedDTO.decRating
            };
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                task.intStatusId = (int)TasksConstant.taskStatus.completed;
                task.strComment = completedDTO?.strComment;
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
    }
}
