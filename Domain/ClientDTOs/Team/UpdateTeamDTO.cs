using System.Text.Json.Serialization;

namespace Domain.ClientDTOs.Team
{
    public class UpdateTeamDTO
    {
        [JsonIgnore]
        public string strUsername { get; set; }
        public int intTeamId { get; set; } = 0;
        public int intDepartmentId { get; set; } = 0;
        public int intNewLeaderID { get; set; } = 0;
        public List<TeamMemberDTO> lstTeamMembers { get; set; } = new List<TeamMemberDTO>();

    }
}