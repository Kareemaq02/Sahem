using Domain.Helpers;

namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintsAnalyticsDTO
    {
        public int intRegionId { get; set; }
        public int intCount { get; set; }
        public int completedComplaints { get; set; }
        public int rejectedComplaints { get; set; }
        public int pendingComplaints { get; set; }
        public int refiledComplaints { get; set; }
        public int scheduledComplaints { get; set; }
        public int waitingEvaluationComplaints { get; set; }
        public int inProgressComplaints { get; set ; }
        public string strRegionNameAr { get; set; }
        public string strRegionNameEn { get; set; }


    }
}
