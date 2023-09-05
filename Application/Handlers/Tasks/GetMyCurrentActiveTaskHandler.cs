using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Tasks
{
    public class GetMyCurrentActiveTaskHandler
        : IRequestHandler<GetMyCurrentActiveTasksQuery, Result<ActiveTaskDTO>>
    {
        private readonly DataContext _context;

        public GetMyCurrentActiveTaskHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<ActiveTaskDTO>> Handle(
            GetMyCurrentActiveTasksQuery request,
            CancellationToken cancellationToken
        )
        {

            var userId = await _context.Users
                .Where(u => u.UserName == request.strUsername)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var query =
                from t in _context.Tasks
                join tT in _context.TaskTypes on t.intTypeId equals tT.intId
                join tm in _context.Teams on t.intTeamId equals tm.intId
                join tc in _context.TasksComplaints on t.intId equals tc.intTaskId
                join teamMembers in _context.TeamMembers on tm.intId equals teamMembers.intTeamId
               where teamMembers.intWorkerId == userId && t.intStatusId == (int)TasksConstant.taskStatus.inProgress
                select new ActiveTaskDTO
                {
                    taskID = t.intId,
                    strTypeNameEn = tT.strNameEn,
                    strTypeNameAr = tT.strNameAr,
                    activatedDate = t.dtmDateActivated,
                    strComment = t.strComment,
                    deadlineDate = t.dtmDateDeadline,
                    lstMedia = t.Complaints
                      .SelectMany(c => c.Complaint.Attachments.Select(a => new Media
                      {
                          Data = File.Exists(a.strMediaRef)
                                    ? Convert.ToBase64String(File.ReadAllBytes(a.strMediaRef))
                                    : string.Empty,
                          IsVideo = a.blnIsVideo
                      }))
                            .ToList(),

                    latLng = _context.ComplaintAttachments
                                .Where(ca => ca.intComplaintId == tc.intComplaintId)
                                .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                                .FirstOrDefault(),
                    blnIsLeader = tm.intLeaderId == userId
                };

            var result = await query.FirstOrDefaultAsync();

            if (result != null)
            {
                return Result<ActiveTaskDTO>.Success(result);
            }
            else
                return Result<ActiveTaskDTO>.Failure("No active task found");
        }
    }
}
