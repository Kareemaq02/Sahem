using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetWatchedComplaintsHandler
        : IRequestHandler<GetWatchedComplaintsQuery, Result<List<WatchedComplaintDTO>>>
    {
        private readonly DataContext _context;

        public GetWatchedComplaintsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<WatchedComplaintDTO>>> Handle(
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
                    firstnameAr = ui.strFirstNameAr,
                    lastnameAr = ui.strLastNameAr,
                    username = u.UserName,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    strStatusEn = cs.strName,
                    strStatusAr = cs.strName,
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
                        new WatchedComplaintDTO
                        {
                            strFirstName = c.firstname,
                            strLastName = c.lastname,
                            strLastNameAr = c.lastnameAr,
                            strFirstNameAr = c.firstnameAr,
                            intComplaintId = c.Complaint.intId,
                            intTypeId = c.Complaint.intTypeId,
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
                            == (int)ComplaintsConstant.complaintStatus.completed
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<WatchedComplaintDTO>>.Success(result);
        }
    }
}
