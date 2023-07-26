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
    public class GetTasksListHandler : IRequestHandler<GetTasksListQuery, Result<List<TaskListDTO>>>
    {
        private readonly DataContext _context;

        public GetTasksListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<TaskListDTO>>> Handle(
            GetTasksListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
            from t in _context.Tasks
            join u in _context.Users on t.intAdminId equals u.Id
            join tT in _context.TaskTypes on t.intTypeId equals tT.intId
            join ts in _context.TaskStatus on t.intStatusId equals ts.intId
            join tm in _context.TaskMembers on t.intId equals tm.intTaskId
            group tm by new
            {
                TaskID = t.intId,
                Admin = u.UserName,
                TaskTypeEn = tT.strNameEn,
                TaskTypeAr = tT.strNameAr,
                ActivationDate = t.dtmDateActivated,
                FinishedDate = t.dtmDateFinished,
                ScheduledDate = t.dtmDateScheduled,
                DeadlineDate = t.dtmDateDeadline,
                TaskStatus = ts.strName
            } into g
            select new TaskListDTO
            {
                taskID = g.Key.TaskID,
                adminUsername = g.Key.Admin,
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
                    strFirstName = x.Worker.UserInfo.strFirstName,
                    strLastName = x.Worker.UserInfo.strLastName,
                    isLeader = x.blnIsLeader,
                }).Distinct().ToList()
            };



            var result = await query.ToListAsync();

            return Result<List<TaskListDTO>>.Success(result);
        }
    }
}
