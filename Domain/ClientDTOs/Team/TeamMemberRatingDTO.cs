namespace Domain.ClientDTOs.Team
{
    public class TeamMemberRatingDTO
    {
        public int intWorkerId { get; set; }
        public string strMemberFirstNameAr { get; set; }
        public string strMemberLastNameAr { get; set; }
        public string strMemberFirstNameEn { get; set; }
        public string strMemberLastNameEn { get; set; }
        public decimal decMemberRating { get; set; }
    }
}