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
    public class GetTasksListHandler
        : IRequestHandler<GetTasksListQuery, Result<PagedList<TaskListDTO>>>
    {
        private readonly DataContext _context;

        public GetTasksListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<TaskListDTO>>> Handle(
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
                orderby g.Key.TaskID ascending
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
                    workersList = g.Select(
                            x =>
                                new TaskWorkerDTO { intId = x.Worker.Id, isLeader = x.blnIsLeader, }
                        )
                        .Distinct()
                        .ToList()
                };

            var queryObject = query.AsQueryable();
            var result = await PagedList<TaskListDTO>.CreateAsync(
                queryObject,
                request.PagingParams.PageNumber,
                request.PagingParams.PageSize
            );

            return Result<PagedList<TaskListDTO>>.Success(result);
        }
    }
}
