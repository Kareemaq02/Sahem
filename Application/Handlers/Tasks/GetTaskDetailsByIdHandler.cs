using Application.Core;
using Application.Queries.Complaints;
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
                join u in _context.Users on t.intAdminId equals u.Id
                join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                join tT in _context.TaskTypes on t.intTypeId equals tT.intId
                join ts in _context.TaskStatus on t.intStatusId equals ts.intId
                join tm in _context.TeamMembers on t.intId equals tm.intTeamId
                where t.intId == request.Id
                group tm by new
                {
                    TaskID = t.intId,
                    TaskTypeEn = tT.strNameEn,
                    TaskTypeAr = tT.strNameAr,
                    CreationDate = t.dtmDateCreated,
                    ActivationDate = t.dtmDateActivated,
                    FinishedDate = t.dtmDateFinished,
                    ScheduledDate = t.dtmDateScheduled,
                    LastModifiedDate = t.dtmDateLastModified,
                    Comment = t.strComment,
                    DeadlineDate = t.dtmDateDeadline,
                    TaskStatus = ts.strName,
                    Cost = t.decCost,
                    UserRating = t.decUserRating,
                    AdminFirstName = ui.strFirstName,
                    AdminLastName = ui.strLastName,
                } into g
                select new DetailedTaskDTO
                {
                    taskID = g.Key.TaskID,
                    createdDate = g.Key.CreationDate,
                    strTypeNameEn = g.Key.TaskTypeEn,
                    strTypeNameAr = g.Key.TaskTypeAr,
                    activatedDate = g.Key.ActivationDate,
                    lastModifiedDate = g.Key.LastModifiedDate,
                    strComment = g.Key.Comment,
                    strAdminFirstName = g.Key.AdminFirstName,
                    strAdminLastName = g.Key.AdminLastName,
                    decCost = g.Key.Cost,
                    decUserRating = g.Key.UserRating,
                    finishedDate = g.Key.FinishedDate,
                    scheduledDate = g.Key.ScheduledDate,
                    deadlineDate = g.Key.DeadlineDate,
                    strTaskStatus = g.Key.TaskStatus,
                    workersList = g.Select(
                            x =>
                                new TaskWorkerDTO
                                {
                                    intId = x.Worker.Id,
                                    //isLeader = x.blnIsLeader,
                                    strFirstName = x.Worker.UserInfo.strFirstName,
                                    strLastName = x.Worker.UserInfo.strLastName
                                }
                        )
                        .Distinct()
                        .ToList(),
                    lstMedia = lstMedia
                };

            var result = await query.FirstOrDefaultAsync();

            return Result<DetailedTaskDTO>.Success(result);
        }
    }
}
