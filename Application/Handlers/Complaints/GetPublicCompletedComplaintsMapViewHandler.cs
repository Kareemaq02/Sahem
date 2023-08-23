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
    public class GetPublicCompletedComplaintsMapViewHandler
        : IRequestHandler<GetPublicCompletedComplaintsMapViewQuery, Result<List<PublicCompletedComplaintsMapViewDTO>>>
    {
        private readonly DataContext _context;
        public GetPublicCompletedComplaintsMapViewHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<PublicCompletedComplaintsMapViewDTO>>> Handle(
            GetPublicCompletedComplaintsMapViewQuery request,
            CancellationToken cancellationToken
        )
        {


            var query =
                from c in _context.Complaints
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
                where(
                c.intStatusId == (int)ComplaintsConstant.complaintStatus.completed
                    && c.intPrivacyId == (int)ComplaintsConstant.complaintPrivacy.privacyPublic)
                select new
                {
                    Complaint = c,
                    c.intTypeId,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    ComplaintGrade = ct.decGrade,
                    strStatusAr = cs.strNameAr,
                    strStatusEn = cs.strName,
                    statusId = cs.intId,
                    latLng = c.Attachments
                        .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                        .FirstOrDefault(),
                };

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var result = await query
                .AsNoTracking()
                .OrderByDescending(q => q.Complaint.dtmDateCreated)
                .Select(
                     c =>

                        new PublicCompletedComplaintsMapViewDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            dtmDateFinished = c.Complaint.Tasks.
                            Select(t => t.Task.dtmDateFinished).FirstOrDefault(),
                            intTypeId = c.intTypeId,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            intStatusId = c.statusId,
                            strStatusAr = c.strStatusAr,
                            strStatusEn = c.strStatusEn,
                            strAddress = "ADDRESS GOES HERE",
                            /*blnIsOnWatchList = c.Complaint.Watchers
                                 .Any(cw => cw.intUserId == userId && cw.intComplaintId == c.Complaint.intId),*/
                            //TODO implement it after thesis along with voting

                            latLng = c.latLng,
                            lstMediaAfter = c.Complaint.Attachments
                            .Where(ca => ca.blnIsFromWorker == true)
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
                            .Where(ca => ca.blnIsFromWorker == false)
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
                .ToListAsync();

            return Result<List<PublicCompletedComplaintsMapViewDTO>>.Success(result);
        }
    }
}