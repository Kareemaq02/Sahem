using Domain.ClientDTOs.User;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Task
{
    public class TaskDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public decimal? decCost { get; set; }
        public DateTime scheduledDate { get; set; }
        public DateTime deadlineDate { get; set; }
        public string strComment { get; set; }
        public List<TaskWorkerDTO> workersList { get; set; }
    }
}
