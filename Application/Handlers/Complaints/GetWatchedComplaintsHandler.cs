using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetWatchedComplaintsHandler
        : IRequestHandler<GetWatchedComplaintsQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetWatchedComplaintsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
            GetWatchedComplaintsQuery request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var query =
                from cw in _context.ComplaintWatchers
                join c in _context.Complaints on cw.intComplaintId equals c.intId
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
                join u in _context.Users on c.intUserID equals u.Id
                join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                where (cw.intUserId == userId)
                select new
                {
                    Complaint = c,
                    firstname = ui.strFirstName,
                    lastname = ui.strLastName,
                    username = u.UserName,
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
                .Select(
                    c =>
                        new ComplaintsListDTO
                        {
                            strUserName = c.username,
                            strFirstName = c.firstname,
                            strLastName = c.lastname,
                            intTypeId = c.Complaint.intTypeId,
                            lstMedia = _context.ComplaintAttachments
                            .Where(ca=> ca.intComplaintId == c.Complaint.intId)
                            
                            .Select(
                                    ca =>
                                        new Media
                                        {
                                            Data = File.Exists(ca.strMediaRef)
                                                ? Convert.ToBase64String(
                                                    File.ReadAllBytes(ca.strMediaRef)
                                                )
                                                : string.Empty,
                                            IsVideo = ca.blnIsVideo
                                        }
                                )
                                .ToList(),

                            intStatusId = c.Complaint.intStatusId,
                            intComplaintId = c.Complaint.intId,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            dtmDateFinished = DateTime.MinValue, // TODO MUST CHANGE WHEN TASK AND COMPLAINTS RELATIONSHIP IS DECIDED
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
                            intVotersCount = c.UpVotes - c.DownVotes
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<ComplaintsListDTO>>.Success(result);
        }
    }
}
