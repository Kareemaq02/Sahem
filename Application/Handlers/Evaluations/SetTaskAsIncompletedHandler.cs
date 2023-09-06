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
using Application.Commands;

namespace Application.Handlers.Evaluations
{
    public class SetTaskAsIncompletedHandler
        : IRequestHandler<IncompleteTaskCommand, Result<IncompleteDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;
        public SetTaskAsIncompletedHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler
        )
        {
            _context = context;
            _userManager = userManager;
            _changeTransactionHandler = changeTransactionHandler;
        }

        public async Task<Result<IncompleteDTO>> Handle(
            IncompleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var incompleteDTO = new IncompleteDTO
            {
                strComment = request.IncompleteDTO?.strComment,
                decRating = request.IncompleteDTO.decRating,
                lstCompletedIds = request.IncompleteDTO.lstCompletedIds,
                lstFailedIds = request.IncompleteDTO.lstFailedIds,
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

                foreach (int complaintId in request.IncompleteDTO.lstCompletedIds)
                {
                    //completed
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.completed;
                    await _context.SaveChangesAsync(cancellationToken);

                    await _changeTransactionHandler.Handle(
                         new AddComplaintStatusChangeTransactionCommand(
                                 complaintId,
                                 (int)ComplaintsConstant.complaintStatus.completed
                             ),
                                 cancellationToken
                             );
                    await _context.SaveChangesAsync(cancellationToken);

                }
                
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update complaint status.");
            }
            try
            {

                foreach (int complaintId in request.IncompleteDTO.lstFailedIds)
                {
                    //failed
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.pending;
                    await _context.SaveChangesAsync(cancellationToken);

                    var complaintTransaction = await _context.ComplaintsStatuses
                                      .Where(c => c.intComplaintId == complaintId && c.intStatusId
                                      != (int)ComplaintsConstant.complaintStatus.pending)
                                      .OrderBy(q => q.dtmTransDate)
                                      .FirstOrDefaultAsync(cancellationToken);

                    if(complaintTransaction!=null)
                    _context.ComplaintsStatuses.Remove(complaintTransaction);

                    await _context.SaveChangesAsync(cancellationToken);

                    await _changeTransactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                                complaintId,
                                (int)ComplaintsConstant.complaintStatus.pending
                            ),
                                cancellationToken
                            );
                    await _context.SaveChangesAsync(cancellationToken);
                }

            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<IncompleteDTO>.Failure("Failed to update complaint status.");
            }

          
            await transaction.CommitAsync();
            return Result<IncompleteDTO>.Success(incompleteDTO);
        }
    }
}
