using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class GeneralComplaintsListDTO
    {
        public int intComplaintId { get; set; }
        public string strFirstName { get; set; }
        public string strLastName { get; set; }
        public DateTime dtmDateCreated { get; set; }
        public string strAddress {get; set; }
        public int intTypeId { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComplaintTypeAr { get; set; }
        public string strComment { get; set; }
        public int intStatusId { get; set; }
        public string strStatusEn { get; set; }
        public string strStatusAr { get; set; }
        public int intVoted { get; set; }
        public int intVotersCount { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMedia { get; set; }
        public bool blnIsOnWatchList { get; set; }
    }
}
