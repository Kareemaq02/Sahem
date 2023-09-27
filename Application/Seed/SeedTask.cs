using Application;
using Application.Commands;
using Application.Core;
using Application.Queries.Complaints;
using Application.Seed.Images;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Evaluation;
using Domain.ClientDTOs.Task;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Utilities.Zlib;
using Persistence;
using System.Data.Entity;
using System.Threading.Tasks;
using System;
using Domain.DataModels.Tasks;

namespace Application.Seed
{
    public class SeedTask
    {
        public static async Task Seed(IMediator _mediator, int iterations)
        {
            var filter = new ComplaintsFilter
            {
                PageSize = 200,
                lstComplaintStatusIds = new List<int> { 1 },
            };
            var complaints = await _mediator.Send(
                new GetComplaintsListQuery(filter, "admin", false)
            );
            List<int> ids5 = complaints.Value
                .Where(c => c.intTypeId == 5)
                .Select(c => c.intComplaintId)
                .ToList();
            List<int> ids9 = complaints.Value
                .Where(c => c.intTypeId == 9)
                .Select(c => c.intComplaintId)
                .ToList();
            List<int> ids19 = complaints.Value
                .Where(c => c.intTypeId == 19)
                .Select(c => c.intComplaintId)
                .ToList();

            int count5 = ids5.Count / 2;
            int count9 = ids9.Count / 2;
            int count19 = ids19.Count / 2;

            var random = new Random();

            int dayOffset = 0;
            for (int i = 0; i < iterations / 3 && i < count5; i++)
            {
                TaskDTO taskDTO = new TaskDTO
                {
                    decCost = (decimal)(random.NextDouble() * 1000),
                    strUserName = "admin",
                    scheduledDate = DateTime.Now + TimeSpan.FromDays(dayOffset),
                    deadlineDate = DateTime.Now + TimeSpan.FromDays(1 + dayOffset),
                    strComment = "",
                    intTeamId = 1,
                    intTaskType = 5,
                    lstComplaintIds = new List<int> { ids5.Skip(i).FirstOrDefault() },
                };
                dayOffset += 5;
                await _mediator.Send(new InsertTaskCommand(taskDTO));
            }

            for (int i = 0; i < iterations / 3 && i < count9; i++)
            {
                TaskDTO taskDTO = new TaskDTO
                {
                    decCost = (decimal)(random.NextDouble() * 1000),
                    strUserName = "admin",
                    scheduledDate = DateTime.Now + TimeSpan.FromDays(dayOffset),
                    deadlineDate = DateTime.Now + TimeSpan.FromDays(1 + dayOffset),
                    strComment = "",
                    intTeamId = 1,
                    intTaskType = 9,
                    lstComplaintIds = new List<int> { ids9.Skip(i).FirstOrDefault() },
                };
                dayOffset += 5;
                await _mediator.Send(new InsertTaskCommand(taskDTO));
            }

            for (int i = 0; i < iterations / 3 && i < count19; i++)
            {
                TaskDTO taskDTO = new TaskDTO
                {
                    decCost = (decimal)(random.NextDouble() * 1000),
                    strUserName = "admin",
                    scheduledDate = DateTime.Now + TimeSpan.FromDays(dayOffset),
                    deadlineDate = DateTime.Now + TimeSpan.FromDays(1 + dayOffset),
                    strComment = "",
                    intTeamId = 1,
                    intTaskType = 19,
                    lstComplaintIds = new List<int> { ids19.Skip(i).FirstOrDefault() }
                };
                dayOffset += 5;
                await _mediator.Send(new InsertTaskCommand(taskDTO));
            }
        }

        public static async Task Activate(WorkTask task, IMediator _mediator)
        {
            // Activate Task
            await _mediator.Send(new ActivateTaskCommand(task.intId, "leader"));
        }

        public static async Task Submit(DataContext _context, IMediator _mediator, WorkTask task)
        {
            // Submit Task
            var random = new Random();
            var membersIds = _context.TeamMembers
                .Where(tm => tm.intTeamId == 1 && tm.intWorkerId != 3)
                .Select(tm => tm.intWorkerId)
                .ToList();

            List<TaskWorkerRatingDTO> ratings = new List<TaskWorkerRatingDTO>();
            foreach (var member in membersIds)
            {
                var randomRate = random.Next(4) * 0.5 + 2.0;
                ratings.Add(
                    new TaskWorkerRatingDTO
                    {
                        intWorkerId = member,
                        decRating = (decimal)randomRate
                    }
                );
            }

            // Type
            int[] typeIds = { 5, 9, 19 };
            int index = random.Next(0, typeIds.Length);
            int typeId = typeIds[index];

            // Image Path
            string scriptDirectory = Path.GetDirectoryName(
                System.Reflection.Assembly.GetExecutingAssembly().Location
            );
            string randomImage = random.Next(1, 4) + ".jpg";
            string file = Path.Combine("Seed", "Images", "After", typeId.ToString(), randomImage);
            string filePath = Path.Combine(scriptDirectory, file);

            var complaintId = _context.TasksComplaints
                .Where(tc => tc.intTaskId == task.intId)
                .Select(tc => tc.intComplaintId)
                .FirstOrDefault();

            var latLng = _context.ComplaintAttachments
                .Where(ca => ca.intComplaintId == complaintId)
                .Select(ca => new LatLng { decLat = ca.decLat, decLng = ca.decLng })
                .FirstOrDefault();

            var media = new List<SubmitTaskAttatchmentsDTO>
            {
                new SubmitTaskAttatchmentsDTO
                {
                    intComplaintId = complaintId,
                    fileMedia = ImageLocalUpload.CreateIFormFileFromLocalFile(filePath),
                    decLatLng = latLng,
                    blnIsVideo = false,
                }
            };

            var submitTaskDTO = new SubmitTaskDTO
            {
                strComment = task.strComment,
                lstWorkersRatings = ratings,
                strUserName = "leader",
                lstMedia = media
            };

            await _mediator.Send(new SubmitTaskCommand(submitTaskDTO, task.intId));
        }

        public static async Task EvaluateToComplete(WorkTask task, IMediator _mediator)
        {
            // Evaluation
            var random = new Random();
            EvaluationDTO completedDTO = new EvaluationDTO
            {
                decRating = (decimal)(random.Next(4) * 0.5 + 2.0),
                strUserName = "admin"
            };
            await _mediator.Send(new CompleteTaskCommand(completedDTO, task.intId));
        }
    }
}
