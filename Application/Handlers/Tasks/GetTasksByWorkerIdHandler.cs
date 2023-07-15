using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.DataModels.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Tasks
{
    public class GetTasksByWorkerIdHandler : IRequestHandler<GetTasksByWorkerIdQuery, Result<List<WorkerTaskDTO>>>
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
            join u in _context.Users on t.intAdminId equals u.Id
            join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
            join tT in _context.TaskTypes on t.intTypeId equals tT.intId
            join ts in _context.TaskStatus on t.intStatusId equals ts.intId
            join tm in _context.TaskMembers on t.intId equals tm.intTaskId
            where tm.intWorkerId == request.id
            group tm by new
            {
                AdminFirstName = ui.strFirstName,
                AdminLastName = ui.strLastName,
                TaskTypeEn = tT.strNameEn,
                TaskTypeAr = tT.strNameAr,
                ActivationDate = t.dtmDateActivated,
                FinishedDate = t.dtmDateFinished,
                ScheduledDate = t.dtmDateScheduled,
                DeadlineDate = t.dtmDateDeadline,
                TaskStatus = ts.strName
            } into g
            select new WorkerTaskDTO
            {
                strAdminFirstName = g.Key.AdminFirstName,
                strAdminLastName = g.Key.AdminLastName,
                strTypeNameEn = g.Key.TaskTypeEn,
                strTypeNameAr = g.Key.TaskTypeAr,
                activatedDate = g.Key.ActivationDate,
                finishedDate = g.Key.FinishedDate,
                scheduledDate = g.Key.ScheduledDate,
                deadlineDate = g.Key.DeadlineDate,
                strTaskStatus = g.Key.TaskStatus,
                workersList = g.Select(x => new TaskWorkerDTO
                {
                    intId = x.Worker.Id,
                    isLeader = x.blnIsLeader,
                }).Distinct().ToList()
            };



            var result = await query.ToListAsync();

            return Result<List<WorkerTaskDTO>>.Success(result);
        }
    }
}
