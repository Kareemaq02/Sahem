using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Evaluation
{
    public class EvaluationDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public string strComment { get; set; }
        public decimal decRating { get; set; }
    }
}
