using Application.Core;
using Application.Queries.Professions;
using Domain.ClientDTOs.Profession;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Departments
{
    public class GetProfessionsListHandler
        : IRequestHandler<GetProfessionsListQuery, Result<List<ProfessionDTO>>>
    {
        private readonly DataContext _context;

        public GetProfessionsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ProfessionDTO>>> Handle(
            GetProfessionsListQuery request,
            CancellationToken cancellationToken
        )
        {
            List<ProfessionDTO> result = await _context.Professions
                .Select(
                    q =>
                        new ProfessionDTO
                        {
                            strNameAr = q.strNameAr,
                            strNameEn = q.strNameEn,
                        }
                )
                .ToListAsync();

            return Result<List<ProfessionDTO>>.Success(result);
        }
    }
}
