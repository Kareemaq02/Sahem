using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsByUserHandler
        : IRequestHandler<GetComplaintsByUserQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsByUserHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
            GetComplaintsByUserQuery request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var query =
                from c in _context.Complaints
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
                select new
                {
                    Complaint = c,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    Status = cs.strName,
                    privacyId = cp.intId,
                    privacyStrAr = cp.strNameAr,
                    privacyStrEn = cp.strNameEn,
                    UpVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && !cv.blnIsDownVote),
                    DownVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && cv.blnIsDownVote)
                };

            var result = await query
                .AsNoTracking()
                .Where(q => q.Complaint.intUserID == userId)
                .Select(
                    c =>
                        new ComplaintsListDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            dtmDateFinished = DateTime.MinValue, // MUST CHANGE WHEN TASK AND COMPLAINTS RELATIONSHIP IS DECIDED
                            strStatus = c.Status,
                            intPrivacyId = c.privacyId,
                            strPrivacyAr = c.privacyStrAr,
                            strPrivacyEn = c.privacyStrEn,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            latLng = _context.ComplaintAttachments
                                .Where(ca => ca.intComplaintId == c.Complaint.intId)
                                .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                                .FirstOrDefault(),
                            strComment = c.Complaint.strComment,
                            intVotersCount = c.UpVotes - c.DownVotes,
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<ComplaintsListDTO>>.Success(result);
        }
    }
}
