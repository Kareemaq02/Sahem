using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Team
{
    public class CreateTeamDTO
    {
        [JsonIgnore]
        public string strUsername { get; set; }
        [JsonIgnore]
        public int intTeamId { get; set; } = 0;
        public int intDepartmentId { get; set; }
        public List<TeamMemberDTO> lstTeamMembers { get; set; } = new List<TeamMemberDTO>();

    }
}