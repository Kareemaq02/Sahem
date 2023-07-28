using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Task;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetTaskTypesListHandler
        : IRequestHandler<GetTaskTypesListQuery, Result<List<TaskTypeDTO>>>
    {
        private readonly DataContext _context;

        public GetTaskTypesListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<TaskTypeDTO>>> Handle(
            GetTaskTypesListQuery request,
            CancellationToken cancellationToken
        )
        {
            List<TaskTypeDTO> result = await _context.TaskTypes
                .Where(q => q.blnIsDeleted != true)
                .Select(
                    q =>
                        new TaskTypeDTO
                        {
                            intId = q.intId,
                            strNameAr = q.strNameAr,
                            strNameEn = q.strNameEn,
                        }
                )
                .ToListAsync();

            return Result<List<TaskTypeDTO>>.Success(result);
        }
    }
}
