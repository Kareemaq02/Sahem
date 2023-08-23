using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class PublicCompletedComplaintsDTO
    {
        public string strFirstNameAr { get; set; }
        public string strLastNameAr { get; set; }
        public string strFirstName { get; set; } 
        public string strLastName { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public DateTime dtmDateFinished { get; set; }
        public int intTypeId { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMediaAfter { get; set; }
        public List<Media> lstMediaBefore { get; set; }
    }
}
