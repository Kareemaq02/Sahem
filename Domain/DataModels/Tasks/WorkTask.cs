using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace Domain.DataModels.Tasks
{
    [Table("tasks")]
    public class WorkTask
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("ADMIN_ID")]
        [ForeignKey("Admin")]
        public int intAdminId { get; set; }
        public ApplicationUser Admin { get; set; }

        [Column("TEAM_ID")]
        [ForeignKey("Team")]
        public int intTeamId { get; set; }
        public Team Team { get; set; }

        [Column("STATUS_ID")]
        [ForeignKey("Status")]
        [Required]
        public int intStatusId { get; set; }
        public WorkTaskStatus Status { get; set; }

        [Column("TYPE_ID")]
        [ForeignKey("TaskType")]
        [Required]
        public int intTypeId { get; set; }
        public WorkTaskType TaskType { get; set; }

        [Column("COST")]
        [Required]
        public decimal decCost { get; set; }

        [Column("DATE_SCHEDULED")]
        [Required]
        public DateTime dtmDateScheduled { get; set; }

        [Column("DATE_ACTIVATED")]
        [Required]
        public DateTime dtmDateActivated { get; set; }

        [Column("DATE_FINISHED")]
        [Required]
        public DateTime dtmDateFinished { get; set; }

        [Column("DATE_DEADLINE")]
        [Required]
        public DateTime dtmDateDeadline { get; set; }

        [Column("COMMENT")]
        [AllowNull]
        public string strComment { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; }

        [Column("LAST_MODIFIED_BY")]
        [Required]
        [ForeignKey("ModifiedBy")]
        public int intLastModifiedBy { get; set; }
        ApplicationUser ModifiedBy { get; set; }

        [Column("DATE_LAST_MODIFIED")]
        [AllowNull]
        public DateTime dtmDateLastModified { get; set; }

        [Column("RATING")]
        [Required]
        public decimal decRating { get; set; }

        [Column("USER_RATING")]
        [Required]
        public decimal decUserRating { get; set; }

        [Column("IS_DELETED")]
        public Boolean blnIsDeleted { get; set; }

        [Column("IS_ACTIVATED")]
        public Boolean blnIsActivated { get; set; }

        // Relations
        public ICollection<WorkTaskComplaints> Complaints { get; set; }
    }
}
