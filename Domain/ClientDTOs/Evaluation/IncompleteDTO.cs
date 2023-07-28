using Domain.ClientDTOs.Task;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Evaluation
{
    public class IncompleteDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public string strComment { get; set; }
        public decimal decRating { get; set; }
        public TaskDTO taskDTO { get; set; }
    }
}
