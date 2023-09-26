using Application.Seed.Images;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Seed
{
    public class SeedComplaint
    {
        public static async Task Seed(IMediator _mediator)
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

            InsertComplaintDTO complaintDTO = new InsertComplaintDTO
            {
                intTypeId = typeId,
                intPrivacyId = 2,
                strComment = "",
                lstMedia = media
            };

            await _mediator.Send(new InsertComplaintCommand(complaintDTO));
        }
    }
}
