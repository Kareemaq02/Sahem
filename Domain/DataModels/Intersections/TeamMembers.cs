using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("team_members")]
    public class TeamMembers
    {
        [Column("WORKER_ID")]
        [ForeignKey("Worker")]
        public int intWorkerId { get; set; }
        public ApplicationUser Worker { get; set; }

        [Column("TEAM_ID")]
        [ForeignKey("Task")]
        public int intTeamId { get; set; }
        public Team Team { get; set; }

        [Column("IS_LEADER")]
        public Boolean blnIsLeader { get; set; }
    }
}
