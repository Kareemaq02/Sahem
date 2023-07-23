using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintByIdHandler
        : IRequestHandler<GetComplaintByIdQuery, Result<ComplaintViewDTO>>
    {
        private readonly DataContext _context;

        public GetComplaintByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<ComplaintViewDTO>> Handle(
            GetComplaintByIdQuery request,
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
                .Where(c => c.Complaint.intId == request.Id)
                .Select(
                    c =>
                        new ComplaintViewDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            strUserName = c.UserName,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            lstMedia = c.Complaint.Attachments
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
                            strStatus = c.Status,
                            strComment = c.Complaint.strComment,
                            intPrivacyId = c.privacyId,
                            strPrivacyAr = c.privacyStrAr,
                            strPrivacyEn = c.privacyStrEn,
                            intVoted = c.Complaint.Voters
                                .Select(cv => cv.blnIsDownVote ? -1 : 1)
                                .FirstOrDefault(),
                            intVotersCount = c.UpVotes - c.DownVotes,
                            latLng = c.latLng,
                        }
                )
                .FirstOrDefaultAsync(cancellationToken);

            if (result == null)
            {
                return Result<ComplaintViewDTO>.Failure("Complaint not found");
            }

            return Result<ComplaintViewDTO>.Success(result);
        }
    }
}
