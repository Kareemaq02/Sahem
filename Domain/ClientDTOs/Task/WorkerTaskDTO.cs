using Domain.ClientDTOs.User;


namespace Domain.ClientDTOs.Task
{
    public class WorkerTaskDTO
    {
        public DateTime activatedDate { get; set; }
        public DateTime finishedDate { get; set; }
        public DateTime scheduledDate { get; set; }
        public DateTime deadlineDate { get; set; }
        public string strAdminFirstName { get; set; }
        public string strAdminLastName { get; set; }
        public string strTypeNameEn { get; set; }
        public string strTypeNameAr { get; set; }
        public string strTaskStatus { get; set; }
        public List<TaskWorkerDTO> workersList { get; set; }

    }
}
