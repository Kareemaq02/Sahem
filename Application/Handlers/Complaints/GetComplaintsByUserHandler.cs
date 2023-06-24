using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsByUserHandler
        : IRequestHandler<GetComplaintsByUserQuery, Result<List<ComplaintsListDTO>>>
    {
        private readonly DataContext _context;

        public GetComplaintsByUserHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ComplaintsListDTO>>> Handle(
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
                select new
                {
                    Complaint = c,
                    ComplaintTypeEn = ct.strNameEn,
                    ComplaintTypeAr = ct.strNameAr,
                    Status = cs.strName,
                };

            var result = await query
                .AsNoTracking()
                .Where(q => q.Complaint.intUserID == userId)
                .Select(
                    c =>
                        new ComplaintsListDTO
                        {
                            intComplaintId = c.Complaint.intId,
                            dtmDateCreated = c.Complaint.dtmDateCreated,
                            dtmDateFinished = DateTime.MinValue, // MUST CHANGE AFTER NEXT MEETING WHEN TASK AND COMPLAINTS RELATIONSHIP IS DECIDED
                            strStatus = c.Status,
                            intPrivacyId = c.Complaint.intPrivacyId,
                            strComplaintTypeEn = c.ComplaintTypeEn,
                            strComplaintTypeAr = c.ComplaintTypeAr,
                            latLng = _context.ComplaintAttachments
                                .Where(ca => ca.intComplaintId == c.Complaint.intId)
                                .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                                .FirstOrDefault(),
                            strComment = c.Complaint.strComment,
                            intVotersCount = _context.ComplaintVoters
                                .Where(cv => cv.intComplaintId == c.Complaint.intId)
                                .Count(),
                        }
                )
                .ToListAsync(cancellationToken);

            return Result<List<ComplaintsListDTO>>.Success(result);
        }
    }
}
