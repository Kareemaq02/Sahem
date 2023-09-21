using Domain.ClientDTOs.Task;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Evaluation
{
    public class IncompleteDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public string strComment { get; set; }
        public int intNewTaskTypeId { get; set; }
        public decimal decRating { get; set; }
        public decimal? decCost { get; set; }
        public DateTime dtmNewScheduled { get; set; }
        public DateTime dtmNewDeadline { get; set; }
        public List<int> lstCompletedIds { get; set; } = new List<int>();
        public List<int> lstFailedIds { get; set; } = new List<int>();
    }
}
