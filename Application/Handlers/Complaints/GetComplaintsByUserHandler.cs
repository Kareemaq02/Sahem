using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsByUserHandler
        : IRequestHandler<GetComplaintsByUserQuery, Result<List<MyComplaintDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsByUserHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<MyComplaintDTO>>> Handle(
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
                    strStatusAr = cs.strNameAr,
                    strStatusEn = cs.strName,
                    privacyId = cp.intId,
                    privacyStrAr = cp.strNameAr,
                    privacyStrEn = cp.strNameEn,
                    UpVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && !cv.blnIsDownVote),
                    DownVotes = _context.ComplaintVoters
                        .AsNoTracking()
                        .Count(cv => cv.intComplaintId == c.intId && cv.blnIsDownVote),
                    intTaskId = c.Tasks.Where(q => q.intComplaintId == c.intId).Select(q => q.intTaskId).FirstOrDefault()
                };

    
            var result = await query
                .AsNoTracking()
                .Where(q => q.Complaint.intUserID == userId)
                .Select(
                    c =>
                        new MyComplaintDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            intTypeId  = c.Complaint.intTypeId,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            dtmDateFinished = c.Complaint.Tasks.Select(q => q.Task.dtmDateFinished).FirstOrDefault(),
                            intStatusId = c.Complaint.intStatusId,
                            strStatusAr = c.strStatusAr,
                            strStatusEn = c.strStatusEn,
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
                            lstMediaAfter = c.Complaint.Attachments
                            .Where(q => q.blnIsFromWorker == true)
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
                            lstMediaBefore = c.Complaint.Attachments
                            .Where(q => q.blnIsFromWorker == false)
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
                            blnIsCompleted = c.Complaint.intStatusId
                            == (int)ComplaintsConstant.complaintStatus.completed,
                            blnIsRated =  _context.TaskRatings.Where(q => q.intTaskId == c.intTaskId && q.intUserId == userId).Any()
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<MyComplaintDTO>>.Success(result);
        }
    }
}
