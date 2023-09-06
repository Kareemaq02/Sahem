using Domain.ClientDTOs.User;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Task
{
    public class UpdateTaskDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public DateTime scheduledDate { get; set; }
        public DateTime deadlineDate { get; set; }
        public string strComment { get; set; }
        public int intTeamId { get; set; } = 0;
        public int intTaskTypeId { get; set; }
    }
}
