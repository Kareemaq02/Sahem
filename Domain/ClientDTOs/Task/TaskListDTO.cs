using Domain.ClientDTOs.User;

namespace Domain.ClientDTOs.Task
{
    public class TaskListDTO
    {
        public int taskID { get; set; }
        public DateTime activatedDate { get; set; }
        public DateTime finishedDate { get; set; }
        public DateTime scheduledDate { get; set; }
        public DateTime deadlineDate { get; set; }
        public string adminUsername { get; set; }
        public int intTaskTypeId { get; set; }
        public string strTypeNameAr { get; set; }
        public string strTypeNameEn { get; set; }
        public int intTaskStatusId { get; set; }
        public string strTaskStatus { get; set; }
        public List<TaskWorkerDTO> workersList { get; set; }
    }
}
