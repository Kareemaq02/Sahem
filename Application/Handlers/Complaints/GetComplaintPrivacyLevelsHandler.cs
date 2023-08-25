using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Department;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Departments
{
    public class GetComplaintPrivacyLevelsHandler
        : IRequestHandler<GetComplaintPrivacyLevelsListQuery, Result<List<PrivacyLevelsDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintPrivacyLevelsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<PrivacyLevelsDTO>>> Handle(
            GetComplaintPrivacyLevelsListQuery request,
            CancellationToken cancellationToken
        )
        {
            List<PrivacyLevelsDTO> result = await _context.ComplaintPrivacy
                .Select(
                    q =>
                        new PrivacyLevelsDTO
                        {
                            intId = q.intId,
                            strNameAr = q.strNameAr,
                            strNameEn = q.strNameEn,
                        }
                )
                .ToListAsync();

            return Result<List<PrivacyLevelsDTO>>.Success(result);
        }
    }
}
