using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Task;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Tasks
{
    public class GetTasksByWorkerIdHandler
        : IRequestHandler<GetTasksByWorkerIdQuery, Result<List<WorkerTaskDTO>>>
    {
        private readonly DataContext _context;

        public GetTasksByWorkerIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<WorkerTaskDTO>>> Handle(
            GetTasksByWorkerIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from t in _context.Tasks
                join tm in _context.TeamMembers on t.intTeamId equals tm.intTeamId
                join ui in _context.UserInfos on request.id equals ui.intId
                join tT in _context.TaskTypes on t.intTypeId equals tT.intId
                join ts in _context.TaskStatus on t.intStatusId equals ts.intId
                where tm.intWorkerId == request.id
                orderby t.intId
                select new WorkerTaskDTO
                {
                    scheduledDate = t.dtmDateScheduled,
                    activatedDate = t.dtmDateActivated,
                    deadlineDate = t.dtmDateDeadline,
                    finishedDate = t.dtmDateFinished,
                    strAdminFirstName = t.Admin.UserInfo.strFirstName,
                    strAdminLastName = t.Admin.UserInfo.strLastName,
                    strTaskStatus = ts.strName,
                    strTypeNameAr = tT.strNameAr,
                    strTypeNameEn = tT.strNameEn,
                    taskId = t.intId,
                    blnIsTaskLeader = t.Team.intLeaderId == request.id,
                    blnIsActive = t.blnIsActivated
                };

            var result = await query.ToListAsync();

            return Result<List<WorkerTaskDTO>>.Success(result);
        }
    }
}