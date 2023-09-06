using Domain.Helpers;

namespace Domain.ClientDTOs.Task
{
    public class ActiveTaskDTO
    {
        public int taskID { get; set; }
        public DateTime deadlineDate { get; set; }
        public DateTime activatedDate { get; set; }
        public string strComment { get; set; }
        public string strTypeNameAr { get; set; }
        public string strTypeNameEn { get; set; }
        public LatLng latLng { get; set; }
        public List<Media> lstMedia { get; set; }
        public bool blnIsLeader { get; set; }
    }
}