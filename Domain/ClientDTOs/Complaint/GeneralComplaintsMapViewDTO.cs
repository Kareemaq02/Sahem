using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class GeneralComplaintsMapViewDTO
    {
        public int intComplaintId { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public string strAddress { get; set; } = "Null for now";
        public int intTypeId { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public int intStatusId { get; set; }
        public string strStatusEn { get; set; }
        public string strStatusAr { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMedia { get; set; }
        public bool blnIsOnWatchList { get; set; }
    }
}
