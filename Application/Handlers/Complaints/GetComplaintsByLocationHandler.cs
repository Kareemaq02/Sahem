using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsByLocationHandler
        : IRequestHandler<GetComplaintsByLocationQuery, Result<PagedList<ComplaintsListDTO>>>
    {
        private readonly IConfiguration _configuration;
        private readonly DataContext _context;

        public GetComplaintsByLocationHandler(IConfiguration configuration, DataContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        public async Task<Result<PagedList<ComplaintsListDTO>>> Handle(
            GetComplaintsByLocationQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from c in _context.Complaints
                join u in _context.Users on c.intUserID equals u.Id
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join ca in _context.ComplaintAttachments on c.intId equals ca.intComplaintId
                group new
                {
                    c,
                    u,
                    ct,
                    cs,
                    ca
                } by new
                {
                    ComplaintId = c.intId,
                    ComplaintDateCreated = c.dtmDateCreated,
                    ComplaintComment = c.strComment,
                    Privacy = c.intPrivacyId,
                    UserName = u.UserName,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    ComplaintGrade = ct.decGrade,
                    Status = cs.strName,
                } into g
                select new
                {
                    g.Key.ComplaintId,
                    g.Key.ComplaintDateCreated,
                    g.Key.ComplaintComment,
                    g.Key.Privacy,
                    g.Key.UserName,
                    g.Key.ComplaintTypeEn,
                    g.Key.ComplaintTypeAr,
                    g.Key.ComplaintGrade,
                    g.Key.Status,
                    LatLng = g.Select(
                            q => new LatLng { decLat = q.ca.decLat, decLng = q.ca.decLng }
                        )
                        .ToList(),
                };

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var queryObject = await query
                .AsNoTracking()
                .Where(cg => cg.Privacy == 2)
                .Select(
                    cg =>
                        new ComplaintsListDTO
                        {
                            intComplaintId = cg.ComplaintId,
                            strUserName = cg.UserName,
                            dtmDateCreated = cg.ComplaintDateCreated,
                            strComplaintTypeEn = cg.ComplaintTypeEn,
                            strComplaintTypeAr = cg.ComplaintTypeAr,
                            strComment = cg.ComplaintComment,
                            strStatus = cg.Status,
                            latLng = cg.LatLng[0],
                            intVotersCount = _context.ComplaintVoters
                                .AsNoTracking()
                                .Where(cv => cv.intComplaintId == cg.ComplaintId)
                                .Count(),
                        }
                )
                .ToListAsync(cancellationToken);

            var fixedResult = new List<ComplaintsListDTO>();
            foreach (var item in queryObject)
            {
                if (
                    HaversineHelper.HaversineDistance(request.latLng, item.latLng)
                    <= int.Parse(_configuration["ComplaintRadiusInMeters"])
                )
                    fixedResult.Add(item);
            }

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var result = await PagedList<ComplaintsListDTO>.CreateAsync(
                fixedResult,
                request.PagingParams.PageNumber,
                request.PagingParams.PageSize
            );

            return Result<PagedList<ComplaintsListDTO>>.Success(result);
        }
    }
}
