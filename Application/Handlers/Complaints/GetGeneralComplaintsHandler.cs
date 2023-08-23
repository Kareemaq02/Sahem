using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using Domain.Resources;
using LinqKit;
using MediatR;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Index.HPRtree;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetGeneralComplaintsHandler
        : IRequestHandler<GetGeneralComplaintsListQuery, Result<PagedList<GeneralComplaintsListDTO>>>
    {
        private readonly DataContext _context;
        public GetGeneralComplaintsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<GeneralComplaintsListDTO>>> Handle(
            GetGeneralComplaintsListQuery request,
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
                join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                join cp in _context.ComplaintPrivacy on c.intPrivacyId equals cp.intId
                select new
                {
                    Complaint = c,
                    ui.strFirstNameAr,
                    ui.strLastNameAr,
                    u.UserName,
                    ui.strFirstName,
                    ui.strLastName,
                    u.blnIsVerified,
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
                    UpVotes = c.Voters.Count(cv => !cv.blnIsDownVote),
                    DownVotes = c.Voters.Count(cv => cv.blnIsDownVote),
                    

                };

            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var queryObject = await query
                .Where(c => c.Complaint.intStatusId != (int)ComplaintsConstant.complaintStatus.completed
                && c.Complaint.intStatusId != (int)ComplaintsConstant.complaintStatus.rejected
                && c.Complaint.intPrivacyId==(int)ComplaintsConstant.complaintPrivacy.privacyPublic)
                .AsNoTracking()
                .OrderByDescending (q => q.Complaint.dtmDateCreated)
                .Select(
                     c =>

                        new GeneralComplaintsListDTO
                        {
                            strFirstNameAr = c.strFirstNameAr,
                            strLastNameAr = c.strLastNameAr,
                            intComplaintId = c.Complaint.intId,
                            strFirstName = c.strFirstName,
                            strLastName = c.strLastName,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            intTypeId = c.intTypeId,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            strComment = c.Complaint.strComment,
                            intStatusId = c.statusId,
                            strStatusEn = c.strStatusEn,
                            strStatusAr =c.strStatusAr,
                            intVoted = c.Complaint.Voters
                                .Select(cv => cv.blnIsDownVote ? -1 : 1)
                                .FirstOrDefault(),
                            intVotersCount = c.UpVotes - c.DownVotes,
                            latLng = c.latLng,
                            lstMedia =  c.Complaint.Attachments
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
                            blnIsOnWatchList = c.Complaint.Watchers
                                 .Any(cw => cw.intUserId == userId && cw.intComplaintId == c.Complaint.intId),

                           /* strAddress = GetStateNameTemp.getStateNameByLatLng
                                 (c.latLng.decLat, c.latLng.decLng), *///TODO This makes the request very slow fetch from database when ready instead
                            blnIsVerified = c.blnIsVerified

                      }
                )
                .ToListAsync();


            // Filter in-memory ONLY FOR GENERAL PRIORITY
            if (request.filter.lstComplaintStatusIds.Count > 0
                && !(request.filter.lstComplaintStatusIds.Contains((int)ComplaintsConstant.complaintStatus.completed)
                 && !(request.filter.lstComplaintStatusIds.Contains((int)ComplaintsConstant.complaintStatus.rejected))
                 ))
            {
                var predicate = PredicateBuilder.New <GeneralComplaintsListDTO>();
                foreach (var filter in request.filter.lstComplaintStatusIds)
                {
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intStatusId == tempFilter);
                }
                queryObject = queryObject.Where(predicate).ToList();
            }

            if (request.filter.lstComplaintTypeIds.Count > 0)
            {
                var predicate = PredicateBuilder.New<GeneralComplaintsListDTO>();
                foreach (var filter in request.filter.lstComplaintTypeIds)
                {
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intTypeId == tempFilter);
                }
                queryObject = queryObject.Where(predicate).ToList();
            }

            if (request.filter.dtmDateCreated > DateTime.MinValue)
                queryObject = queryObject
                    .Where(q => q.dtmDateCreated >= request.filter.dtmDateCreated)
                    .ToList();

            if (request.filter.intDistanceInKm > 0)
            {
                var predicate = PredicateBuilder.New<GeneralComplaintsListDTO>();
                    predicate = predicate.Or(item =>
                    HaversineHelper.HaversineDistance(request.userLocation,new LatLng{decLat = item.latLng.decLat,
                    decLng = item.latLng.decLng})<= request.filter.intDistanceInKm * 1000);

                queryObject = queryObject.Where(predicate).ToList();
            }
            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            var result = await PagedList<GeneralComplaintsListDTO>.CreateAsync(
                queryObject,
                request.filter.PageNumber,
                request.filter.PageSize
            );

            return Result<PagedList<GeneralComplaintsListDTO>>.Success(result);
        }
    }
}