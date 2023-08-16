using Domain.Helpers;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintsListDTO
    {
        public int intComplaintId { get; set; }
        public string strUserName { get; set; }
        public string strFirstName { get; set; } 
        public string strLastName { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public DateTime dtmDateFinished { get; set; }
        public int intTypeId { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public string strComment { get; set; }
        public int intStatusId { get; set; }
        public string strStatus { get; set;}
        public int intPrivacyId { get; set; }
        public string strPrivacyAr { get; set; }
        public string strPrivacyEn { get; set; }
        public int intVoted { get; set; }
        public int intVotersCount { get; set; }
        public LatLng latLng { get; set; }
        public decimal decPriority { get; set; }
        public List<Media> lstMedia { get; set; }
    }
}
