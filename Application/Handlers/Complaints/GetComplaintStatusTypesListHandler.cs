using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.SharedDTOs;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintStatusTypesListHandler
        : IRequestHandler<GetComplaintStatusTypesListQuery, Result<List<StatusDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintStatusTypesListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<StatusDTO>>> Handle(
            GetComplaintStatusTypesListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from q in _context.ComplaintStatus
                select new StatusDTO
                {
                    intId = q.intId,
                    strName = q.strName
                };

            var result = await query
                .AsNoTracking().ToListAsync();

            return Result<List<StatusDTO>>.Success(result);
        }
    }
}
