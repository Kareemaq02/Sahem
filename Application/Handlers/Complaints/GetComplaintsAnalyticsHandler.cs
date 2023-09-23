using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Resources;
using LinqKit;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;
using Persistence.Migrations;
using System.Linq;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsAnalyticsHandler
        : IRequestHandler<GetComplaintsAnalyticsQuery, Result<List<ComplaintsAnalyticsDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsAnalyticsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsAnalyticsDTO>>> Handle(
            GetComplaintsAnalyticsQuery request,
            CancellationToken cancellationToken
        )
        {

            var complaintsCountQuery =
                from c in _context.Complaints
                select c;

            var complaintsCountQueryObject = await complaintsCountQuery.ToListAsync();


            if(request.filter.dtmDateCreated > DateTime.MinValue)
                complaintsCountQueryObject = complaintsCountQueryObject
                    .Where(q => q.dtmDateCreated >= request.filter.dtmDateCreated)
                    .ToList();

            if (request.filter.dtmDateTo > DateTime.MinValue)
                complaintsCountQueryObject = complaintsCountQueryObject
                    .Where(q => q.dtmDateCreated <= request.filter.dtmDateTo)
                    .ToList();

            if (request.filter.lstComplaintTypeIds.Count > 0)
            {
                var predicate = PredicateBuilder.New<Complaint>();
                foreach (var filter in request.filter.lstComplaintTypeIds)
                {
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intTypeId == tempFilter);
                }
                complaintsCountQueryObject = complaintsCountQueryObject.Where(predicate).ToList();
            }

        


            var totalComplaintsCount = complaintsCountQueryObject.Count();


            var query =
                from c in _context.Complaints
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                select new
                {
                    Complaint = c,
                    c.intTypeId,
                    c.intStatusId,
                    c.dtmDateCreated,
                    ct.strNameEn,
                    ct.strNameAr
                    
                };
            if (request.filter.dtmDateCreated > DateTime.MinValue)
            {
                query = query.Where(c => c.dtmDateCreated >= request.filter.dtmDateCreated);
            }
            if (request.filter.dtmDateTo > DateTime.MinValue)
            {
                query = query.Where(c => c.dtmDateCreated <= request.filter.dtmDateTo);
            }
            // NOT OPTIMIZED USE OTHER REFERENCES FOR HELP
            if (request.filter.lstComplaintTypeIds.Count > 0)
            {
                query = query.Where(dto =>
                    request.filter.lstComplaintTypeIds.Contains(dto.intTypeId));
            }

            var queryObject = await query
                .AsNoTracking()
                .GroupBy(c => new {c.Complaint.intRegionId })
                .Select( groupedComplaints =>
                    new ComplaintsAnalyticsDTO
                    {
                        intRegionId = groupedComplaints.Key.intRegionId,
                        strRegionNameAr = _context.Regions
                        .Where( q => q.intId == groupedComplaints.Key.intRegionId)
                        .Select(q => q.strNameAr).SingleOrDefault(),
                        strRegionNameEn = _context.Regions
                        .Where(q => q.intId == groupedComplaints.Key.intRegionId)
                        .Select(q => q.strNameEn).SingleOrDefault(),
                        intCount = groupedComplaints.Count(),
                        pendingComplaints = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.pending),
                        completedComplaints  =groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.completed),
                        refiledComplaints  = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.refiled),
                        rejectedComplaints  = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.rejected),
                        scheduledComplaints  = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.Scheduled),
                        waitingEvaluationComplaints = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.waitingEvaluation),
                        inProgressComplaints  = groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.inProgress)
                    })
                .ToListAsync();




            // Filter in-memory ONLY FOR GENERAL PRIORITY


           





            return Result<List<ComplaintsAnalyticsDTO>>.Success(queryObject);
        }
    }
}