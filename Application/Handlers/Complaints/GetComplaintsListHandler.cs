using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsListHandler
        : IRequestHandler<GetComplaintsListQuery, Result<PagedList<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<ComplaintsListDTO>>> Handle(
            GetComplaintsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var query =
                from c in _context.Complaints
                join u in _context.Users on c.intUserID equals u.Id
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
                select new
                {
                    Complaint = c,
                    u.UserName,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    ComplaintGrade = ct.decGrade,
                    Status = cs.strName,
                    privacyId = cp.intId,
                    privacyStrAr = cp.strNameAr,
                    privacyStrEn = cp.strNameEn,
                    latLng = c.Attachments
                        .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                        .FirstOrDefault(),
                    UpVotes = c.Voters.Count(cv => !cv.blnIsDownVote),
                    DownVotes = c.Voters.Count(cv => cv.blnIsDownVote)
                };

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var queryObject = await query
                .AsNoTracking()
                .OrderBy(q => q.Complaint.intId)
                .Select(
                    c =>
                        new ComplaintsListDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            strUserName = c.UserName,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComment = c.Complaint.strComment,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            strStatus = c.Status,
                            intPrivacyId = c.privacyId,
                            strPrivacyAr = c.privacyStrAr,
                            strPrivacyEn = c.privacyStrEn,
                            intVoted = c.Complaint.Voters
                                .Select(cv => cv.blnIsDownVote ? -1 : 1)
                                .FirstOrDefault(),
                            intVotersCount = c.UpVotes - c.DownVotes,
                            latLng = c.latLng,
                            decPriority =
                                c.ComplaintGrade
                                * (
                                    c.Complaint.intReminder
                                    + (c.UpVotes - c.DownVotes)
                                    + (DateTime.UtcNow.Ticks - c.Complaint.dtmDateCreated.Ticks)
                                )
                        }
                )
                .ToListAsync(cancellationToken: cancellationToken);

            if (queryObject.Count > 0)
            {
                decimal minPriority = queryObject.Min(c => c.decPriority);
                decimal maxPriority = queryObject.Max(c => c.decPriority);
                decimal range = maxPriority - minPriority;

                if (range > 0)
                {
                    foreach (var complaint in queryObject)
                    {
                        complaint.decPriority = (complaint.decPriority - minPriority) / range;
                    }
                }
            }

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var result = await PagedList<ComplaintsListDTO>.CreateAsync(
                queryObject,
                request.PagingParams.PageNumber,
                request.PagingParams.PageSize
            );

            return Result<PagedList<ComplaintsListDTO>>.Success(result);
        }
    }
}
