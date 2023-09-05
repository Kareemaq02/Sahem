using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.Helpers;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Tasks
{
    public class GetTaskDetailsByIdHandler
        : IRequestHandler<GetTaskDetailsByIdQuery, Result<DetailedTaskDTO>>
    {
        private readonly DataContext _context;

        public GetTaskDetailsByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<DetailedTaskDTO>> Handle(
            GetTaskDetailsByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var lstMediaQuery =
                from ta in _context.ComplaintAttachments
                where ta.blnIsFromWorker == true
                select new MediaDTO
                {
                    strMediaRef = File.Exists(ta.strMediaRef)
                        ? Convert.ToBase64String(File.ReadAllBytes(ta.strMediaRef))
                        : string.Empty,
                    blnIsVideo = ta.blnIsVideo
                };

            var lstMedia = lstMediaQuery.Distinct().ToList();

            var query =
                from t in _context.Tasks
                join ui in _context.UserInfos on t.intAdminId equals ui.intId
                join tT in _context.TaskTypes on t.intTypeId equals tT.intId
                join ts in _context.TaskStatus on t.intStatusId equals ts.intId
                join tm in _context.Teams on t.intTeamId equals tm.intId
                where t.intId == request.Id
                select new DetailedTaskDTO
                {
                    taskID = t.intId,
                    createdDate = t.dtmDateCreated,
                    strTypeNameEn = tT.strNameEn,
                    strTypeNameAr = tT.strNameAr,
                    activatedDate = t.dtmDateActivated,
                    lastModifiedDate = t.dtmDateLastModified,
                    strComment = t.strComment,
                    strAdminFirstName = ui.strFirstName,
                    strAdminLastName = ui.strLastName,
                    decCost = t.decCost,
                    decUserRating = t.decUserRating,
                    finishedDate = t.dtmDateFinished,
                    scheduledDate = t.dtmDateScheduled,
                    deadlineDate = t.dtmDateDeadline,
                    strTaskStatus = ts.strName,
                    intTeamId = t.intTeamId,
                    workersList = t.Team.Workers
                                .Select(
                                    ca =>
                                        new TaskWorkerDTO
                                        {
                                            intId = ca.intWorkerId,
                                            strFirstName = ca.Worker.UserInfo.strFirstName,
                                            strLastName = ca.Worker.UserInfo.strLastName,
                                            isLeader = t.Team.intLeaderId == ca.intWorkerId
                                        }
                                )
                                .ToList()
                };

            var result = await query.FirstOrDefaultAsync();

            return Result<DetailedTaskDTO>.Success(result);
        }
    }
}
