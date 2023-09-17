namespace Domain.ClientDTOs.Team
{
    public class TeamListDTO
    {
        public int intTeamId { get; set; }
        public int intTeamLeaderId { get; set; }
        public int intDepartmentId { get; set; }
        public string strTeamLeaderFirstNameEn { get; set; }
        public string strTeamLeaderLastNameEn { get; set; }
        public string strTeamLeaderFirstNameAr { get; set; }
        public string strTeamLeaderLastNameAr { get; set; }
        public string strDepartmentNameAr { get; set; }
        public string strDepartmentNameEn { get; set; }
    }
}