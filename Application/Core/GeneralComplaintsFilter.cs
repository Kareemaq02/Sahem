namespace Application.Core
{
    public class GeneralComplaintsFilter : PagingParams
    {
        public List<int> lstComplaintStatusIds { get; set; } = new List<int>();
        public List<int> lstComplaintTypeIds { get; set; } = new List<int>();
        public DateTime dtmDateCreated { get; set; } = DateTime.MinValue;
        public DateTime dtmDateTo { get; set; } = DateTime.MinValue;
        public int intDistanceInKm { get; set; } = 0;
    }
}
