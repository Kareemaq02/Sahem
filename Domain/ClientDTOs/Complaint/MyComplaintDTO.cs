using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class MyComplaintDTO
    {
        public int intComplaintId { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public DateTime dtmDateFinished { get; set; }
        public int intTypeId { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public string strComment { get; set; }
        public int intStatusId { get; set; }
        public string strStatusAr { get; set; }
        public string strStatusEn { get; set; }
        public int intPrivacyId { get; set; }
        public string strPrivacyAr { get; set; }
        public string strPrivacyEn { get; set; }
        public int intVotersCount { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMediaAfter { get; set; }
        public List<Media> lstMediaBefore { get; set; }
        public bool blnIsCompleted { get; set; } 
    }
}
