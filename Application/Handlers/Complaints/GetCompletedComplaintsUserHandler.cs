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
    public class GetCompletedComplaintsUserHandler
        : IRequestHandler<GetCompletedComplaintsUserQuery, Result<List<PublicCompletedComplaintsDTO>>>
    {
        private readonly DataContext _context;

        public GetCompletedComplaintsUserHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<PublicCompletedComplaintsDTO>>> Handle(
            GetCompletedComplaintsUserQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from c in _context.Complaints
                join u in _context.Users on c.intUserID equals u.Id
                join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                where
                    c.intStatusId == (int)ComplaintsConstant.complaintStatus.completed
                    && c.intPrivacyId == (int)ComplaintsConstant.complaintPrivacy.privacyPublic
                select new
                {
                    Complaint = c,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    strStatusAr = cs.strNameAr,
                    strStatusEn = cs.strName,
                    ui.strFirstName,
                    ui.strLastName,
                    ui.strFirstNameAr,
                    ui.strLastNameAr,
                };

            var result = await query
                .AsNoTracking()
                .Select(
                    c =>
                        new PublicCompletedComplaintsDTO
                        {
                            strFirstName = c.strFirstName,
                            strLastName = c.strLastName,
                            strFirstNameAr = c.strFirstNameAr,
                            strLastNameAr = c.strLastNameAr,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            dtmDateFinished = c.Complaint.Tasks.
                            Select(t => t.Task.dtmDateFinished).FirstOrDefault(),
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            intTypeId = c.Complaint.intTypeId,
                            latLng = c.Complaint.Attachments
                        .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                        .FirstOrDefault(),

                            lstMediaAfter =  c.Complaint.Attachments
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
                                .ToList()
                        }
                )
                .ToListAsync(cancellationToken);


            return Result<List<PublicCompletedComplaintsDTO>>.Success(result);
        }
    }
}
