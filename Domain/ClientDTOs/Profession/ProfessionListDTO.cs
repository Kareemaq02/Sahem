using Domain.ClientDTOs.User;
using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Profession
{
    public class ProfessionListDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public int intId { get; set; }
        public string strNameAr { get; set; }
        public string strNameEn { get; set; }
        public List<WorkerDTO> lstProfessionWorkers { get; set; }
    }
}
