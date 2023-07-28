using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class RefileComplaintHandler : IRequestHandler<RefileComplaintCommand, Result<int>>
    {
        private readonly DataContext _context;

        public RefileComplaintHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<int>> Handle(
            RefileComplaintCommand request,
            CancellationToken cancellationToken
        )
        {
            var complaintStatus = await _context.Complaints
                .Where(c => c.intId == request.ID)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (complaintStatus == (int)ComplaintsConstant.complaintStatus.completed)
            {
                var complaint = new Complaint { intId = request.ID };
                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.waitingEvaluation;

                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<int>.Failure("Failed to update the complaint.");

            await _context.SaveChangesAsync();

            return Result<int>.Success(request.ID);
        }
    }
}
