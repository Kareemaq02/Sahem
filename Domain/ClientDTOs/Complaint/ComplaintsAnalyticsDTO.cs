using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintsAnalyticsDTO
    {
        public int intTypeId { get; set; }
        public int intCount { get; set; }
        public float completedComplaintsPercentage { get; set; }
        public float rejectedComplaintsPercentage { get; set; }
        public float pendingComplaintsPercentage { get; set; }
        public float refiledComplaintsPercentage { get; set; }
        public string strNameAr { get; set; }
        public string strNameEn { get; set; }
        
    }
}
