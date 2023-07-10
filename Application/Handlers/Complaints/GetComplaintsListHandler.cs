using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsListHandler
        : IRequestHandler<GetComplaintsListQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
            GetComplaintsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from c in _context.Complaints
                join u in _context.Users on c.intUserID equals u.Id
                join ct in _context.ComplaintTypes on c.intTypeId equals ct.intId
                join cs in _context.ComplaintStatus on c.intStatusId equals cs.intId
                select new
                {
                    Complaint = c,
                    UserName = u.UserName,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    ComplaintGrade = ct.decGrade,
                    Status = cs.strName
                };

            var result = await query
                .AsNoTracking()
                .Select(
                    c =>
                        new ComplaintsListDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            strUserName = c.UserName,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComment = c.Complaint.strComment,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            strStatus = c.Status,
                            decPriority =
                                c.ComplaintGrade
                                * (
                                    (
                                        c.Complaint.intReminder
                                        + _context.ComplaintVoters
                                            .AsNoTracking()
                                            .Where(cv => cv.intComplaintId == c.Complaint.intId)
                                            .Count()
                                    ) + (DateTime.UtcNow.Ticks - c.Complaint.dtmDateCreated.Ticks)
                                )
                        }
                )
                .ToListAsync(cancellationToken);

            if (result.Count > 0)
            {
                decimal minPriority = result.Min(c => c.decPriority);
                decimal maxPriority = result.Max(c => c.decPriority);
                decimal range = maxPriority - minPriority;

                if (range > 0)
                {
                    foreach (var complaint in result)
                    {
                        complaint.decPriority = (complaint.decPriority - minPriority) / range;
                    }
                }
            }

            return Result<List<ComplaintsListDTO>>.Success(result);
        }
    }
}
