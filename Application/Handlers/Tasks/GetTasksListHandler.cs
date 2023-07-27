using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.DataModels.Tasks;
using LinqKit;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;
using System.Linq;

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
                    TaskTypeID = tT.intId,
                    TaskTypeEn = tT.strNameEn,
                    TaskTypeAr = tT.strNameAr,
                    ActivationDate = t.dtmDateActivated,
                    FinishedDate = t.dtmDateFinished,
                    ScheduledDate = t.dtmDateScheduled,
                    DeadlineDate = t.dtmDateDeadline,
                    TaskStatus = ts.strName,
                    StatusId = ts.intId,
                } into g
                orderby g.Key.TaskID ascending
                select new TaskListDTO
                {
                    taskID = g.Key.TaskID,
                    adminUsername = g.Key.Admin,
                    intTaskTypeId = g.Key.TaskTypeID,
                    strTypeNameEn = g.Key.TaskTypeEn,
                    strTypeNameAr = g.Key.TaskTypeAr,
                    activatedDate = g.Key.ActivationDate,
                    finishedDate = g.Key.FinishedDate,
                    scheduledDate = g.Key.ScheduledDate,
                    deadlineDate = g.Key.DeadlineDate,
                    intTaskStatusId = g.Key.StatusId,
                    strTaskStatus = g.Key.TaskStatus,
                    workersList = g.Select(
                            x =>
                                new TaskWorkerDTO { intId = x.Worker.Id, isLeader = x.blnIsLeader, }
                        )
                        .Distinct()
                        .ToList()
                };

            var queryObject = query.AsQueryable();

            // Filter server-side database
            if (request.filter.lstTaskTypeIds.Count > 0)
            {
                var predicate = PredicateBuilder.New<TaskListDTO>();
                foreach (var filter in request.filter.lstTaskTypeIds)
                {
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intTaskTypeId == tempFilter);
                }
                queryObject = queryObject.Where(predicate);
            }

            if (request.filter.lstTaskStatusIds.Count > 0)
            {
                var predicate = PredicateBuilder.New<TaskListDTO>();
                foreach (var filter in request.filter.lstTaskStatusIds)
                {
                    intId = x.Worker.Id,
                    strFirstName = x.Worker.UserInfo.strFirstName,
                    strLastName = x.Worker.UserInfo.strLastName,
                    isLeader = x.blnIsLeader,
                }).Distinct().ToList()
            };
            
                    var tempFilter = filter;
                    predicate = predicate.Or(q => q.intTaskStatusId == tempFilter);
                }
                queryObject = queryObject.Where(predicate);
            }

            //if (request.filter.lstWorkersIds.Count > 0)
            //{
            //    var predicate = PredicateBuilder.New<TaskListDTO>();
            //    foreach (var filter in request.filter.lstWorkersIds)
            //    {
            //        var tempFilter = filter;
            //        predicate = predicate.Or(
            //            q => q.workersList.Exists(worker => worker.intId == tempFilter)
            //        );
            //    }
            //    queryObject = queryObject.Where(predicate);
            //}

            if (!string.IsNullOrEmpty(request.filter.strAdmin))
                queryObject = queryObject.Where(
                    q => q.adminUsername.Equals(request.filter.strAdmin)
                );

            //if (request.filter.intLeaderId > 0)
            //    queryObject = queryObject.Where(
            //        q =>
            //            q.workersList.Any(
            //                worker =>
            //                    worker.intId == request.filter.intLeaderId
            //                    && worker.isLeader == true
            //            )
            //    );

            if (request.filter.dtmDateScheduled > DateTime.MinValue)
                queryObject = queryObject.Where(
                    q => q.scheduledDate >= request.filter.dtmDateScheduled
                );

            if (request.filter.dtmDateActivated > DateTime.MinValue)
                queryObject = queryObject.Where(
                    q => q.activatedDate >= request.filter.dtmDateActivated
                );

            if (request.filter.dtmDateFinished > DateTime.MinValue)
                queryObject = queryObject.Where(
                    q => q.finishedDate >= request.filter.dtmDateFinished
                );

            if (request.filter.dtmDateDeadline > DateTime.MinValue)
                queryObject = queryObject.Where(
                    q => q.deadlineDate >= request.filter.dtmDateDeadline
                );

            var result = await PagedList<TaskListDTO>.CreateAsync(
                queryObject,
                request.filter.PageNumber,
                request.filter.PageSize
            );

            return Result<PagedList<TaskListDTO>>.Success(result);
        }
    }
}
