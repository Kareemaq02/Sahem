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
                join tc in _context.TasksComplaints on ta.intComplaintId equals tc.intComplaintId
                where tc.intTaskId == request.Id
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
                                            strFirstNameAr = ca.Worker.UserInfo.strFirstNameAr,
                                            strLastNameAr = ca.Worker.UserInfo.strLastNameAr,
                                            isLeader = t.Team.intLeaderId == ca.intWorkerId,
                                            decRating =  _context.TasksMembersRatings
                                            .Where(q => q.intUserId == ca.intWorkerId && q.intTaskId == request.Id)
                                            .Select(q => q.decRating).SingleOrDefault()

                                        }
                                )
                                .ToList(),
                    lstMediaAfter = t.Complaints.SelectMany(q => q.Complaint.Attachments
                    .Where( q => q.blnIsFromWorker == true)
                           .Select(q =>
                           new TaskMediaDTO
                           {
                               intComplaintId = q.intComplaintId,
                               blnIsVideo = false,
                               decLatLng = new LatLng { decLat = q.decLat, decLng = q.decLng },
                               Data = File.Exists(q.strMediaRef) ?
                               Convert.ToBase64String(File.ReadAllBytes(q.strMediaRef))
                               : null,
                               region = new RegionNames
                               {
                                   strRegionAr = q.Complaint.Region.strNameAr,
                                   strRegionEn = q.Complaint.Region.strNameEn
                               }

                           })).ToList(),
                    lstMediaBefore = t.Complaints.SelectMany(q => q.Complaint.Attachments
                    .Where(q => q.blnIsFromWorker == false)
                           .Select(q =>
                           new TaskMediaDTO
                           {
                               intComplaintId = q.intComplaintId,
                               blnIsVideo = false,
                               decLatLng = new LatLng { decLat = q.decLat, decLng = q.decLng },
                               Data = File.Exists(q.strMediaRef) ?
                               Convert.ToBase64String(File.ReadAllBytes(q.strMediaRef))
                               : null,
                               region = new RegionNames
                               {
                                   strRegionAr = q.Complaint.Region.strNameAr,
                                   strRegionEn = q.Complaint.Region.strNameEn
                               }

                           })).ToList()

                };

            var result = await query.FirstOrDefaultAsync();

            return Result<DetailedTaskDTO>.Success(result);
        }
    }
}
