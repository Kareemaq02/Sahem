using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Resources;
using LinqKit;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

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


            var queryObject = await query
                .AsNoTracking()
                .GroupBy(c => new { c.intTypeId, c.strNameAr, c.strNameEn })
                .Select(groupedComplaints =>
                    new ComplaintsAnalyticsDTO
                    {
                        intCount = groupedComplaints.Count(),
                        intTypeId = groupedComplaints.Key.intTypeId,
                        strNameAr = groupedComplaints.Key.strNameAr,
                        strNameEn = groupedComplaints.Key.strNameEn,
                        pendingComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.pending) / groupedComplaints.Count() * 100, 2),
                        completedComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.completed) / groupedComplaints.Count() * 100, 2),
                        refiledComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.refiled) / groupedComplaints.Count() * 100, 2),
                        rejectedComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.rejected) / groupedComplaints.Count() * 100, 2),
                        scheduledComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.Scheduled) / groupedComplaints.Count() * 100, 2),
                        waitingEvaluationComplaintsPercentage = (float)Math.Round((float)groupedComplaints.Count(q => q.intStatusId == (int)ComplaintsConstant.complaintStatus.waitingEvaluation) / groupedComplaints.Count() * 100, 2),
                    })
                .ToListAsync();




            // Filter in-memory ONLY FOR GENERAL PRIORITY


            if (request.filter.lstComplaintTypeIds.Count > 0)
            {
                var predicate = PredicateBuilder.New<ComplaintsAnalyticsDTO>();
                foreach (var filter in request.filter.lstComplaintTypeIds)
                {
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intTypeId == tempFilter);
                }
                queryObject = queryObject.Where(predicate).ToList();
            }

            

           


            return Result<List<ComplaintsAnalyticsDTO>>.Success(queryObject);
        }
    }
}