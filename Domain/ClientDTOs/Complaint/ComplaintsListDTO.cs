using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintsListDTO
    {
        public int intComplaintId { get; set; }
        public string strUserName { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public DateTime dtmDateFinished { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public string strComment { get; set; }
        public string strStatus { get; set; }
        public int intPrivacyId { get; set; }
        public int intVotersCount { get; set; }
        public LatLng latLng { get; set; }
        public decimal decPriority { get; set; }
    }
}
