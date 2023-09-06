using Domain.Helpers;
using Microsoft.AspNetCore.Http;

namespace Domain.ClientDTOs.Complaint
{
    public class SubmitTaskAttatchmentsDTO
    {
        public int intComplaintId { get; set; }
        public IFormFile fileMedia { get; set; }
        public Boolean blnIsVideo { get; set; }
        public LatLng decLatLng { get; set; }
    }
}
