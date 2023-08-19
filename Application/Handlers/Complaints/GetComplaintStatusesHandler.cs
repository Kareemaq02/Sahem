using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintStatusesHandler
        : IRequestHandler<GetComplaintStatusesQuery, Result<List<ComplaintStatusesDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintStatusesHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintStatusesDTO>>> Handle(
            GetComplaintStatusesQuery request,
            CancellationToken cancellationToken
        )
        {
            var result = await _context.ComplaintsStatuses
                .Where(q => q.intComplaintId == request.Id)
                .Select(
                    c =>
                        new ComplaintStatusesDTO
                        {
                            intComplaintId = c.intComplaintId,
                            intComplaintStatusId = c.intStatusId,
                            dtmTrans = c.dtmTransDate
                        }
                )
                .ToListAsync();

            foreach (var dto in result)
            {
                var status = await _context.ComplaintStatus
                    .Where(cs => cs.intId == dto.intComplaintStatusId)
                    .FirstOrDefaultAsync(cancellationToken: cancellationToken);

                if (status != null)
                {
                    dto.strStatusName = status.strName;
                    dto.strStatusNameAr = status.strNameAr;
                }
            }

            if (result.Count == 0)
            {
                return Result<List<ComplaintStatusesDTO>>.Failure("No results found");
            }

            return Result<List<ComplaintStatusesDTO>>.Success(result);
        }
    }
}
