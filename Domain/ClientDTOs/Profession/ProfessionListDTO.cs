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
    }
}
