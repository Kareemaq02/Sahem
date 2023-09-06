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

            var isLeader = _context.Teams.Any(tm => tm.intLeaderId == userId); //Assuming that a leader of a team can't be a worker in another team

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
                        task.intStatusId == (int)TasksConstant.taskStatus.inProgress
                    )
                    {
                        task.dtmDateLastModified = DateTime.UtcNow;
                        task.intLastModifiedBy = userId;
                        task.strComment = submitTaskDTO.strComment;
                        task.intStatusId = (int)TasksConstant.taskStatus.waitingEvaluation;
                        await _context.SaveChangesAsync(cancellationToken);

                        if ( lstMedia.Count == 0 )
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

   

                        foreach (var media in lstMedia)
                        {
                            var complaint = new Complaint { intId = media.intComplaintId };
                            _context.Complaints.Attach(complaint);
                            complaint.intStatusId = (int)
                                ComplaintsConstant.complaintStatus.waitingEvaluation;
                            await _context.SaveChangesAsync(cancellationToken);

                            await _changeTransactionHandler.Handle(
                                new AddComplaintStatusChangeTransactionCommand(
                                    media.intComplaintId,
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
                        return Result<SubmitTaskDTO>.Failure("The task has must be active before being submitted");
                }
                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    return Result<SubmitTaskDTO>.Failure("Unknown Error " + e);
                }

                return Result<SubmitTaskDTO>.Success(submitTaskDTO);
            }
            else
                return Result<SubmitTaskDTO>.Failure("Only the leader can submit the task");
        }
    }
}
