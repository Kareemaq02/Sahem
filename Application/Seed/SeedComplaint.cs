using Application.Commands;
using Application.Seed.Images;
using Domain.ClientDTOs.Complaint;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Seed
{
    public class SeedComplaint
    {
        public static async Task Seed(DataContext _context, IMediator _mediator)
        {
            // Type
            int[] typeIds = { 5, 9, 19 };
            Random random = new Random();
            int index = random.Next(0, typeIds.Length);
            int typeId = typeIds[index];

            // Image Path
            string scriptDirectory = Path.GetDirectoryName(
                System.Reflection.Assembly.GetExecutingAssembly().Location
            );
            string randomImage = random.Next(1, 4) + ".jpg";
            string file = Path.Combine("Seed", "Images", "Before", typeId.ToString(), randomImage);
            string filePath = Path.Combine(scriptDirectory, file);
            var media = new List<InsertComplaintAttachmentsDTO>
            {
                new InsertComplaintAttachmentsDTO
                {
                    fileMedia = ImageLocalUpload.CreateIFormFileFromLocalFile(filePath),
                    decLat = (decimal)(random.NextDouble() * 0.03 + 31.9564),
                    decLng = (decimal)(random.NextDouble() * 0.0679 + 35.8570),
                    blnIsVideo = false,
                }
            };

            var username = _context.Users
                .Where(u => u.intUserTypeId == 4)
                .OrderBy(u => u.Id)
                .Select(u => u.UserName)
                .Skip(random.Next(10))
                .FirstOrDefault();

            InsertComplaintDTO complaintDTO = new InsertComplaintDTO
            {
                intTypeId = typeId,
                strUserName = username,
                intPrivacyId = 2,
                strComment = "",
                lstMedia = media
            };

            await _mediator.Send(new InsertComplaintCommand(complaintDTO));
        }

        public static async Task Reject(DataContext _context, IMediator _mediator)
        {
            int totalPendingComplaints = await _context.Complaints.CountAsync(
                c => c.intStatusId == (int)ComplaintsConstant.complaintStatus.pending
            );

            int rejectComplaintsCount = (int)(totalPendingComplaints * 0.05);
            var complaintsToReject = await _context.Complaints
                .Where(c => c.intStatusId == (int)ComplaintsConstant.complaintStatus.pending)
                .OrderBy(c => c.intId)
                .Take(rejectComplaintsCount)
                .Select(c => c.intId)
                .ToListAsync();

            foreach (var id in complaintsToReject)
            {
                await _mediator.Send(new RejectComplaintByIdCommand(id, "admin"));
            }
        }

        public static async Task Vote(DataContext _context, IMediator _mediator)
        {
            int totalPendingComplaints = await _context.Complaints.CountAsync(
                c => c.intStatusId == (int)ComplaintsConstant.complaintStatus.pending
            );

            int votedComplaintsCount = (int)(totalPendingComplaints * 0.2);
            var complaintsToVoteFor = await _context.Complaints
                .Where(c => c.intStatusId == (int)ComplaintsConstant.complaintStatus.pending)
                .OrderBy(c => c.intId)
                .Take(votedComplaintsCount)
                .Select(c => c.intId)
                .ToListAsync();

            var users = await _context.Users
                .Where(u => u.intUserTypeId == 4)
                .OrderBy(u => u.Id)
                .Select(u => u.UserName)
                .ToListAsync();

            foreach (var id in complaintsToVoteFor)
            {
                foreach (var username in users)
                {
                    await _mediator.Send(new InsertVoteCommand(id, username));
                }
            }
        }
    }
}
