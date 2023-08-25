using Application.Commands;
using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using Domain.DataModels.Complaints;
using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using Domain.Resources;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class SubmitTaskByIdHandler : IRequestHandler<SubmitTaskCommand, Result<SubmitTaskDTO>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;

        public SubmitTaskByIdHandler(
            AddComplaintStatusChangeTransactionHandler changeTransactionHandler,
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
        {
            _changeTransactionHandler = changeTransactionHandler;
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
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

            var isLeader = _context.TeamMembers.Any(
                tm =>
                    tm.intTeamId == request.id && tm.intWorkerId == userId && tm.blnIsLeader == true
            );

            if (isLeader)
            {
                var lstMedia = submitTaskDTO.lstMedia;

                using var transaction = await _context.Database.BeginTransactionAsync(
                    cancellationToken
                );
                try
                {
                    var task = await _context.Tasks.FindAsync(request.id);

                    if (
                        task.intStatusId != (int)TasksConstant.taskStatus.waitingEvaluation
                        || task.intStatusId != (int)TasksConstant.taskStatus.completed
                    )
                    {
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
                                    intComplaintId = request.id,
                                    strMediaRef = filePath,
                                    blnIsVideo = media.blnIsVideo,
                                    dtmDateCreated = DateTime.UtcNow,
                                    intCreatedBy = userId,
                                    blnIsFromWorker = true
                                }
                            );
                        }

                        var complaintIds = await _context.TasksComplaints
                            .Where(q => q.intTaskId == request.id)
                            .Select(q => q.intComplaintId)
                            .ToListAsync();

                        foreach (int complaintId in complaintIds)
                        {
                            var complaint = new Complaint { intId = complaintId };
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
                            await _context.SaveChangesAsync(cancellationToken);
                        }
                        // Alter it to link the attachment with the complaint, not the task
                        //await _context.TaskAttachments.AddRangeAsync(taskAttatchments);
                        await transaction.CommitAsync();
                    }
                    else
                        return Result<SubmitTaskDTO>.Failure("The task has already been submitted");
                }
                catch (Exception)
                {
                    await transaction.RollbackAsync();
                    return Result<SubmitTaskDTO>.Failure("Unknown Error");
                }

                return Result<SubmitTaskDTO>.Success(submitTaskDTO);
            }
            else
                return Result<SubmitTaskDTO>.Failure("Only the leader can submit the task");
        }
    }
}
