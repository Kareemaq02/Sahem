using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Complaints;
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
            select new ComplaintTypeDTO
            {
                decGrade = t.decGrade,
                intDepartmentId = t.intDepartmentId,
                strPrivacy = p.strName,
                strNameAr = t.strNameAr,
                strNameEn = t.strNameEn
            };

            var result = await query.ToListAsync();


            return Result<List<ComplaintTypeDTO>>.Success(result);
        }
    }
}
