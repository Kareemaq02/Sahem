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
        : IRequestHandler<GetComplaintsListQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
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
                    UserName = u.UserName,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    ComplaintGrade = ct.decGrade,
                    Status = cs.strName,
                    privacyId = cp.intId,
                    privacyStrAr = cp.strNameAr,
                    privacyStrEn = cp.strNameEn,
                    latLng = _context.ComplaintAttachments
                        .AsNoTracking()
                        .Where(ca => ca.intComplaintId == c.intId)
                        .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                        .FirstOrDefault(),
                    UpVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && !cv.blnIsDownVote),
                    DownVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && cv.blnIsDownVote)
                };

            var result = await query
                .AsNoTracking()
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
                            intVoted = _context.ComplaintVoters
                                .AsNoTracking()
                                .Where(
                                    cv =>
                                        cv.intComplaintId == c.Complaint.intId
                                        && cv.intUserId == userId
                                )
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
                .ToListAsync(cancellationToken);

            if (result.Count > 0)
            {
                decimal minPriority = result.Min(c => c.decPriority);
                decimal maxPriority = result.Max(c => c.decPriority);
                decimal range = maxPriority - minPriority;

                if (range > 0)
                {
                    foreach (var complaint in result)
                    {
                        complaint.decPriority = (complaint.decPriority - minPriority) / range;
                    }
                }
            }

            return Result<List<ComplaintsListDTO>>.Success(result);
        }
    }
}
