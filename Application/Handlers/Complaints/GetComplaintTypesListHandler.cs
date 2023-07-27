using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintTypesListHandler
        : IRequestHandler<GetComplaintTypesListQuery, Result<List<ComplaintTypeDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintTypesListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintTypeDTO>>> Handle(
            GetComplaintTypesListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from t in _context.ComplaintTypes
                join p in _context.ComplaintPrivacy on t.intPrivacyId equals p.intId
                select new
                {
                    t.decGrade,
                    t.intId,
                    t.intDepartmentId,
                    intPrivacyId = p.intId,
                    strPrivacyAr = p.strNameAr,
                    strPrivacyEn = p.strNameEn,
                    t.strNameAr,
                    t.strNameEn,
                    t.blnIsDeleted
                };

            var result = await query
                .AsNoTracking()
                .Where(ct => !ct.blnIsDeleted)
                .Select(
                    t =>
                        new ComplaintTypeDTO
                        {
                            decGrade = t.decGrade,
                            intTypeId = t.intId,
                            intDepartmentId = t.intDepartmentId,
                            intPrivacyId = t.intPrivacyId,
                            strPrivacyEn = t.strPrivacyEn,
                            strPrivacyAr = t.strPrivacyAr,
                            strNameAr = t.strNameAr,
                            strNameEn = t.strNameEn
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<ComplaintTypeDTO>>.Success(result);
        }
    }
}
