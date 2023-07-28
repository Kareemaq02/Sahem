using Application.Core;
using Domain.DataModels.Complaints;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers
{
    public class DeleteComplaintByIdHandler : IRequestHandler<DeleteComplaintCommand, Result<Unit>>
    {
        private readonly DataContext _context;

        public DeleteComplaintByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<Unit>> Handle(
            DeleteComplaintCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var complaintStatus = await _context.Complaints
                    .Where(c => c.intId == request.Id)
                    .Select(c => c.intStatusId)
                    .FirstOrDefaultAsync(cancellationToken);

                if (complaintStatus == (int)ComplaintsConstant.complaintStatus.pending)
                {
                    var complaintAttachments = await _context.ComplaintAttachments
                        .Where(ca => ca.intComplaintId == request.Id)
                        .ToListAsync(cancellationToken);

                    _context.ComplaintAttachments.RemoveRange(complaintAttachments);
                    await _context.SaveChangesAsync(cancellationToken);
                }
                else
                    return Result<Unit>.Failure("Failed to delete the complaint.");
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete complaint.");
            }

            try
            {
                var complaint = new Complaint { intId = request.Id };
                _context.Complaints.Attach(complaint);
                _context.Complaints.Remove(complaint);

                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<Unit>.Failure("Failed to delete complaint.");
            }
            await transaction.CommitAsync();
            return Result<Unit>.Success(Unit.Value);
        }
    }
}
