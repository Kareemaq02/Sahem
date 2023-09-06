using Domain.Helpers;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Complaint
{
    public class InsertComplaintDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public int intId { get; set; } //testing
        public int intTypeId { get; set; }
        public int intPrivacyId { get; set; }
        public bool blnHasSimilar { get; set; } = false;
        public List<Media> similarComplaintLstMedia { get; set; } = new List<Media>();
        public ICollection<InsertComplaintAttachmentsDTO> lstMedia { get; set; }
        public string strComment { get; set; }
        public int intRegionId { get; set; } = 1;
    }
}
