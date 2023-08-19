using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace Domain.DataModels.Complaints
{
    [Table("complaints")]
    public class Complaint
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("USER_ID")]
        [Required]
        public int intUserID { get; set; }

        [Column("TYPE_ID")]
        [ForeignKey("ComplaintType")]
        public int intTypeId { get; set; }
        public ComplaintType ComplaintType { get; set; }

        [Column("STATUS_ID")]
        [Required]
        [ForeignKey("Status")]
        public int intStatusId { get; set; }
        public ComplaintStatus Status { get; set; }

        [Column("PRIVACY_ID")]
        [Required]
        [ForeignKey("Privacy")]
        public int intPrivacyId { get; set; }
        public ComplaintPrivacy Privacy { get; set; }

        [Column("COMMENT")]
        [AllowNull]
        public string strComment { get; set; }

        [Column("REMINDER")]
        [Required]
        public int intReminder { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; }

        [Column("DATE_LAST_REMINDED")]
        [AllowNull]
        public DateTime dtmDateLastReminded { get; set; }

        [Column("LAST_MODIFIED_BY")]
        [Required]
        [ForeignKey("ModifiedBy")]
        public int intLastModifiedBy { get; set; }
        ApplicationUser ModifiedBy { get; set; }

        [Column("DATE_LAST_MODIFIED")]
        [AllowNull]
        public DateTime dtmDateLastModified { get; set; }

        [Column("IS_REFILED")]
        public Boolean blnIsRefiled { get; set; }

        // Relations
        public ICollection<ComplaintVoters> Voters { get; set; }
        public ICollection<ComplaintWatchers> Watchers { get; set; }
        public ICollection<ComplaintAttachment> Attachments { get; set; }
        public ICollection<WorkTaskComplaints> Tasks { get; set; }
        public ICollection<ComplaintsStatuses> Statuses { get; set; }
    }
}
