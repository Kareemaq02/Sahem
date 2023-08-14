namespace Application.Core
{
    public class ComplaintsFilter : PagingParams
    {
        public List<int> lstComplaintStatusIds { get; set; } = new List<int>();
        public List<int> lstComplaintTypeIds { get; set; } = new List<int>();
        public List<int> lstComplaintPrivacyIds { get; set; } = new List<int>();
        public DateTime dtmDateCreated { get; set; } = DateTime.MinValue;
        public int intDistance { get; set; } = 0;
    }
}
