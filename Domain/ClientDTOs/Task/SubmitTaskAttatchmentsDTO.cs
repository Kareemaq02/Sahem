using Microsoft.AspNetCore.Http;

namespace Domain.ClientDTOs.Complaint
{
    public class SubmitTaskAttatchmentsDTO
    {
        public IFormFile fileMedia { get; set; }
        public Boolean blnIsVideo { get; set; }
    }
}
