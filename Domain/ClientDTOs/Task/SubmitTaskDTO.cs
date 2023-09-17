using Domain.ClientDTOs.Complaint;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Task
{
    public class SubmitTaskDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public ICollection<SubmitTaskAttatchmentsDTO> lstMedia { get; set; }
        public string strComment { get; set; }
        public List<TaskWorkerRatingDTO> lstWorkersRatings { get; set; }
    }
}
