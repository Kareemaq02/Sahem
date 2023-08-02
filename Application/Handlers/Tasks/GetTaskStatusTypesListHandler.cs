using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.SharedDTOs;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetTaskStatusTypesListHandler
        : IRequestHandler<GetTaskStatusTypesListQuery, Result<List<StatusDTO>>>
    {
        private readonly DataContext _context;

        public GetTaskStatusTypesListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<StatusDTO>>> Handle(
            GetTaskStatusTypesListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from q in _context.TaskStatus
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
