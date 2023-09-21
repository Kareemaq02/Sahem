using Application.Commands;
using Application.Core;
using Application.Services;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Complaints;
using Domain.DataModels.Intersections;
using Domain.DataModels.Notifications;
using Domain.DataModels.User;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Persistence;
using System.Threading.Tasks;

namespace Application.Handlers.Complaints
{
    public class SubmitTaskByIdHandler : IRequestHandler<SubmitTaskCommand, Result<SubmitTaskDTO>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public SubmitTaskByIdHandler(
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler,
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _changeTransactionHandler = changeTransactionHandler;
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<SubmitTaskDTO>> Handle(
            SubmitTaskCommand request,
            CancellationToken cancellationToken
        )
        {
            var submitTaskDTO = request.SubmitTaskDTO;
            var userId = await _context.Users
                .Where(u => u.UserName == submitTaskDTO.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var task = await _context.Tasks.FindAsync(request.id); ;
            var taskTeam = await _context.Teams.Where(q => q.intId == task.intTeamId).SingleOrDefaultAsync();
            var isLeader = taskTeam.intLeaderId == userId; //Assuming that a leader of a team can't be a worker in another team

            if (isLeader)
            {
                var lstMedia = submitTaskDTO.lstMedia;

                using var transaction = await _context.Database.BeginTransactionAsync(
                    cancellationToken
                );
                try
                {


                    if (task == null)
                        return Result<SubmitTaskDTO>.Failure("Failed to Submit Task");

                    

                    if (
                        task.intStatusId == (int)TasksConstant.taskStatus.inProgress
                    )
                    {
                        var teamMembersCount = await _context.TeamMembers
                        .Where(q => q.intTeamId == task.intTeamId).CountAsync();


                        if ((teamMembersCount - 1) != request.SubmitTaskDTO.lstWorkersRatings.Count())
                        {
                            await transaction.RollbackAsync();
                            return Result<SubmitTaskDTO>.Failure("Failed to Submit Task, you need to rate all workers before submiting");
                        }


                        foreach (var workerRating in request.SubmitTaskDTO.lstWorkersRatings)
                        {
                            if (workerRating.intWorkerId == taskTeam.intLeaderId)
                            {
                                await transaction.RollbackAsync();
                                return Result<SubmitTaskDTO>.Failure("Failed to Submit Task. Leader cant rate himself");
                            }

                            await _context.AddAsync(new WorkTaskMemberRating
                            {
                                intTaskId = task.intId,
                                intUserId = workerRating.intWorkerId,
                                decRating = workerRating.decRating
                            });
                            await _context.SaveChangesAsync();

                        }


                        task.dtmDateLastModified = DateTime.UtcNow;
                        task.intLastModifiedBy = userId;
                        task.strComment = submitTaskDTO.strComment;
                        task.intStatusId = (int)TasksConstant.taskStatus.waitingEvaluation;
                        await _context.SaveChangesAsync(cancellationToken);

                        if (lstMedia.Count == 0)
                        {
                            await transaction.RollbackAsync();
                            return Result<SubmitTaskDTO>.Failure("No file was Uploaded.");
                        }

                        var taskAttatchments = new List<ComplaintAttachment>();
                        foreach (var media in lstMedia)
                        {
                            if (media.fileMedia == null)

                            {
                                await transaction.RollbackAsync();
                                return Result<SubmitTaskDTO>.Failure("No file was Uploaded.");
                            }
                            string extension = Path.GetExtension(media.fileMedia.FileName);
                            string fileName = $"{DateTime.UtcNow.Ticks}{extension}";
                            string directory = _configuration["FilesPath"];
                            string path = Path.Join(
                                DateTime.UtcNow.Year.ToString(),
                                DateTime.UtcNow.Month.ToString(),
                                DateTime.UtcNow.Day.ToString(),
                                request.id.ToString()
                            );
                            string filePath = Path.Join(directory, path, fileName);

                            // Create directory if it doesn't exist
                            Directory.CreateDirectory(Path.Combine(directory, path));

                            // Create file
                            using var stream = File.Create(filePath);
                            await media.fileMedia.CopyToAsync(stream, cancellationToken);


                            taskAttatchments.Add(
                                new ComplaintAttachment
                                {
                                    intComplaintId = media.intComplaintId,
                                    strMediaRef = filePath,
                                    blnIsVideo = media.blnIsVideo,
                                    dtmDateCreated = DateTime.UtcNow,
                                    intCreatedBy = userId,
                                    blnIsFromWorker = true,
                                    decLat = media.decLatLng.decLat,
                                    decLng = media.decLatLng.decLng
                                }

                            );
                        }
                        await _context.ComplaintAttachments.AddRangeAsync(taskAttatchments);
                        await _context.SaveChangesAsync(cancellationToken);

                        List<int> userIds = new List<int>();

                        var complaintIds = await _context.TasksComplaints
                        .Where(q => q.intTaskId == request.id)
                         .Select(q => q.intComplaintId)
                        .ToListAsync();

                        foreach (var complaintId in complaintIds)
                        {
                            try
                            {
                                var complaint = await _context.Complaints
                                .Where(q => q.intId == complaintId)
                                .Select(q => new Complaint
                                {
                                    intId = q.intId,
                                    intUserID = q.intUserID,
                                    intStatusId = q.intStatusId
                                }).SingleOrDefaultAsync();


                                _context.Complaints.Attach(complaint);
                                complaint.intStatusId = (int)
                                    ComplaintsConstant.complaintStatus.waitingEvaluation;
                                await _context.SaveChangesAsync(cancellationToken);

                                await _changeTransactionHandler.Handle(
                                    new AddComplaintStatusChangeTransactionCommand(
                                        complaintId,
                                        (int)ComplaintsConstant.complaintStatus.waitingEvaluation
                                    ),
                                    cancellationToken
                                );
                                userIds.Add(complaint.intUserID);
                                await _context.SaveChangesAsync(cancellationToken);
                            }
                            catch 
                            {
                                await transaction.RollbackAsync();
                                return Result<SubmitTaskDTO>.Failure("Task Submition Failed.");

                            }

                        }


                        try
                        {
                            //Insert into Notifications Table



                            // Get Notification body and header
                            var notificationLayout = await _context.NotificationTypes
                               .Where(q => q.intId == (int)NotificationConstant.NotificationType.waitingEvaluationComplaintNotification)
                               .Select(q => new NotificationLayout
                               {
                                   strHeaderAr = q.strHeaderAr,
                                   strBodyAr = q.strBodyAr,
                                   strBodyEn = q.strBodyEn,
                                   strHeaderEn = q.strHeaderEn
                               }).SingleOrDefaultAsync();

                            if (notificationLayout == null)
                            {
                                await transaction.RollbackAsync();
                                throw new Exception("Notification Type table is empty");
                            }

                            string headerAr = notificationLayout.strHeaderAr;
                            string bodyAr = notificationLayout.strBodyAr;
                            string headerEn = notificationLayout.strHeaderEn;
                            string strBodyEn = notificationLayout.strBodyEn;

                            foreach (int userID in userIds)
                            {
                                await _mediator.
                                    Send(new InsertNotificationCommand(new Notification
                                    {
                                        intTypeId = (int)NotificationConstant.NotificationType.waitingEvaluationComplaintNotification,
                                        intUserId = userID,

                                        strHeaderAr = headerAr,
                                        strBodyAr = bodyAr,

                                        strHeaderEn = headerEn,
                                        strBodyEn = strBodyEn,
                                    }));
                            }


                             _notificationService.SendNotifications(userIds, headerAr, bodyAr);
                        }
                        catch (Exception e)
                        {
                            await transaction.RollbackAsync();
                            return Result<SubmitTaskDTO>.Failure("Failed to Submit Task" + e);

                        }


                        // Alter it to link the attachment with the complaint, not the task
                        //await _context.TaskAttachments.AddRangeAsync(taskAttatchments);
                        await transaction.CommitAsync();
                    }
                    else
                    {
                        await transaction.RollbackAsync();
                        return Result<SubmitTaskDTO>.Failure("The task  must be active before being submitted");
                    }
                }
                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    return Result<SubmitTaskDTO>.Failure("Unknown Error " + e);
                }

                return Result<SubmitTaskDTO>.Success(submitTaskDTO);
            }
            else
            {
                return Result<SubmitTaskDTO>.Failure("Only the leader can submit the task");
            }
        }
    }
}
