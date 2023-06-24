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
    public class GetComplaintsBtLocationHandler
        : IRequestHandler<GetComplaintsBtLocationQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly IConfiguration _configuration;
        private readonly DataContext _context;

        public GetComplaintsBtLocationHandler(IConfiguration configuration, DataContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
            GetComplaintsBtLocationQuery request,
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

            var result = await query
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
            foreach (var item in result)
            {
                if (
                    HaversineHelper.HaversineDistance(request.latLng, item.latLng)
                    <= int.Parse(_configuration["ComplaintRadiusInMeters"])
                )
                    fixedResult.Add(item);
            }

            return Result<List<ComplaintsListDTO>>.Success(fixedResult);
        }
    }
}
