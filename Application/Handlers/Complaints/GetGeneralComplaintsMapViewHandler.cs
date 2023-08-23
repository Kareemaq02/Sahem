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
    public class GetGeneralComplaintsMapViewHandler
        : IRequestHandler<GetGeneralComplaintsMapViewQuery, Result<List<GeneralComplaintsMapViewDTO>>>
    {
        private readonly DataContext _context;
        public GetGeneralComplaintsMapViewHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<GeneralComplaintsMapViewDTO>>> Handle(
            GetGeneralComplaintsMapViewQuery request,
            CancellationToken cancellationToken
        )
        {
 

            var query =
                from c in _context.Complaints
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
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
                .Where(c => c.Complaint.intStatusId != (int)ComplaintsConstant.complaintStatus.completed
                && c.Complaint.intStatusId != (int)ComplaintsConstant.complaintStatus.rejected
                && c.Complaint.intPrivacyId == (int)ComplaintsConstant.complaintPrivacy.privacyPublic)
                .AsNoTracking()
                .OrderByDescending(q => q.Complaint.dtmDateCreated)
                .Select(
                     c =>

                        new GeneralComplaintsMapViewDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
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


                        }
                )
                .ToListAsync();

            return Result<List<GeneralComplaintsMapViewDTO>>.Success(result);
        }
    }
}