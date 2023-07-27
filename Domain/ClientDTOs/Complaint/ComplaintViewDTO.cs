using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintViewDTO
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
        public string strPrivacyAr { get; set; }
        public string strPrivacyEn { get; set; }
        public int intVotersCount { get; set; }
        public int intVoted { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMedia { get; set; }
    }
}
