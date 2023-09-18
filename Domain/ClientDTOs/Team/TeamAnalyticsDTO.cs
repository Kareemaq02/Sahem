namespace Domain.ClientDTOs.Team
{
    public class TeamAnalyticsDTO
    {
        public int intTeamId { get; set; }
        public int intTasksCount{ get; set; }
        public int intTasksCompletedCount { get; set; }
        public int intTasksScheduledCount { get; set; }
        public int intTasksIncompleteCount { get; set; }
        public int intTasksWaitingEvaluationCount { get; set; }
        public decimal decTeamRatingAvg { get; set; }
        public List<TeamMemberRatingDTO> lstMembersAvgRating { get; set; }
    }
}