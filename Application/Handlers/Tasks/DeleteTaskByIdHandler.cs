using Application.Core;
using Domain.DataModels.Complaints;
using Domain.DataModels.Tasks;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers
{
    public class DeleteTaskByIdHandler : IRequestHandler<DeleteTaskCommand, Result<Unit>>
    {
        private readonly DataContext _context;
        private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

        public DeleteTaskByIdHandler(DataContext context,
            AddComplaintStatusChangeTransactionHandler transactionHandler)
        {
            _context = context;
            _transactionHandler = transactionHandler;
        }

        public async Task<Result<Unit>> Handle(
            DeleteTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
           
                var TasksStatus = await _context.Tasks
                    .Where(c => c.intId == request.Id)
                    .Select(c => c.intStatusId)
                    .FirstOrDefaultAsync(cancellationToken);

                if (TasksStatus != (int)TasksConstant.taskStatus.inactive)
                    return Result<Unit>.Failure("Failed to delete the task.");
            try
            {
                var complaintIds = await _context.TasksComplaints
                      .Where(q => q.intTaskId == request.Id)
                      .Select(q => q.intComplaintId)
                      .ToListAsync();

                foreach (int complaintId in complaintIds)
                {
                    var complaint = new Complaint { intId = complaintId };
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.pending;
                    await _context.SaveChangesAsync(cancellationToken);

                    var complaintTransaction = await _context.ComplaintsStatuses
                                       .Where(c => c.intComplaintId == complaintId && c.intStatusId
                                       != (int)ComplaintsConstant.complaintStatus.pending)
                                       .OrderBy(q => q.dtmTransDate)
                                       .FirstOrDefaultAsync(cancellationToken);

                    if (complaintTransaction != null)
                        _context.ComplaintsStatuses.Remove(complaintTransaction);

                    await _context.SaveChangesAsync(cancellationToken);
                }
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete tasks.");
            }


            try
            {
                var taskComplaint = await _context.TasksComplaints
                    .Where(cc => cc.intTaskId == request.Id)
                    .ToListAsync(cancellationToken);

                _context.TasksComplaints.RemoveRange(taskComplaint);
                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete task.");
            }

            try
            {
                var task = new WorkTask { intId = request.Id };
                _context.Tasks.Attach(task);
                _context.Tasks.Remove(task);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete tasks.");
            }
           
            await transaction.CommitAsync();
            return Result<Unit>.Success(Unit.Value);
        }
    }
}
