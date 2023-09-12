using Microsoft.AspNetCore.Http;

namespace Domain.ClientDTOs.Complaint
{
    public class InsertComplaintAttachmentsDTO
    {
        public IFormFile fileMedia { get; set; }
        public decimal decLat { get; set; }
        public decimal decLng { get; set; }
        public Boolean blnIsVideo { get; set; }
    }
}
