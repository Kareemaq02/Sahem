using Application.Core;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using LinqKit;
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

            var userId = await _context.Users
             .Where(u => u.UserName == request.strUsername)
             .Select(u => u.Id)
             .SingleOrDefaultAsync(cancellationToken: cancellationToken);


            var query = from t in _context.Tasks
                        join tt in _context.TaskTypes on t.intTypeId equals tt.intId
                        join ts in _context.TaskStatus on t.intStatusId equals ts.intId
                        join team in _context.Teams on t.intTeamId equals team.intId
                        join d in _context.Departments on team.intDepartmentId equals d.intId
                        orderby t.intId
                       where(t.intAdminId == userId)
                        select new TaskListDTO
                        {
                            taskID = t.intId,
                            strTypeNameEn = tt.strNameEn,
                            strTypeNameAr = tt.strNameAr,
                            strTaskStatus = ts.strName,
                            strTaskStatusAr = ts.strNameAr,
                            strDepartmentEn = d.strNameEn,
                            strDepartmentAr = d.strNameAr,
                            intTaskStatusId = ts.intId,
                            intTaskTypeId = tt.intId,
                            intTeamID = team.intId,
                            activatedDate = t.dtmDateActivated,
                            deadlineDate = t.dtmDateDeadline,
                            finishedDate = t.dtmDateFinished,
                            scheduledDate = t.dtmDateScheduled,
                            adminName = t.Admin.UserInfo.strFirstName + " " + t.Admin.UserInfo.strLastName,
                            adminNameAr = t.Admin.UserInfo.strFirstNameAr + " " + t.Admin.UserInfo.strLastNameAr,
                            adminUsername = t.Admin.UserName,
                            workersList = team.Workers.Select(
                                w => new TaskWorkerDTO
                                {
                                    intId = w.intWorkerId,
                                    strFirstName = w.Worker.UserInfo.strFirstName,
                                    strLastName = w.Worker.UserInfo.strLastName,
                                    strFirstNameAr = w.Worker.UserInfo.strFirstNameAr,
                                    strLastNameAr = w.Worker.UserInfo.strLastNameAr,
                                    isLeader = team.intLeaderId == w.intWorkerId
                                }
                                ).ToList(),
                            lstMedia = t.Complaints.SelectMany(q => q.Complaint.Attachments
                            .Select(q => 
                            new TaskMediaDTO 
                            {
                                intComplaintId = q.intComplaintId,
                                blnIsVideo = false,
                                decLatLng = new Domain.Helpers.LatLng { decLat = q.decLat, decLng = q.decLng },
                                Data = File.Exists(q.strMediaRef) ?
                                Convert.ToBase64String(File.ReadAllBytes(q.strMediaRef))
                                : null,
                                region = new Domain.Helpers.RegionNames
                                {
                                    strRegionAr = q.Complaint.Region.strNameAr,
                                    strRegionEn = q.Complaint.Region.strNameEn
                                }

                            })).ToList(),
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
