using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Evaluation
{
    public class IncompleteDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public string strComment { get; set; }
        public int intNewTaskTypeId { get; set; } // NOT NEEDED
        public decimal decRating { get; set; } // NOT NEEDED
        public decimal? decCost { get; set; } // NOT NEEDED
        public DateTime dtmNewScheduled { get; set; }
        public DateTime dtmNewDeadline { get; set; }
        public List<int> lstCompletedIds { get; set; } = new List<int>(); // NOT NEEDED
        public List<int> lstFailedIds { get; set; } = new List<int>();
    }
}
