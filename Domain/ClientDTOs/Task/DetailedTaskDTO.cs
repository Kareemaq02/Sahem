using Domain.ClientDTOs.User;

namespace Domain.ClientDTOs.Task
{
    public class DetailedTaskDTO
    {
        public int taskID { get; set; }
        public DateTime createdDate { get; set; }
        public DateTime finishedDate { get; set; }
        public DateTime scheduledDate { get; set; }
        public DateTime deadlineDate { get; set; }
        public DateTime lastModifiedDate { get; set; }
        public DateTime activatedDate { get; set; }
        public decimal decUserRating { get; set; }
        public decimal decCost { get; set; }
        public string strComment { get; set; }
        public string strTypeNameAr { get; set; }
        public string strTypeNameEn { get; set; }
        public string strTaskStatus { get; set; }
        public string strAdminFirstName { get; set; }
        public string strAdminLastName { get; set; }
        public List<TaskWorkerDTO> workersList { get; set; }
        public List<MediaDTO> lstMedia { get; set; }
    }
}