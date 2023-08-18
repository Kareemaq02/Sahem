using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace Domain.DataModels.Notifications
{
    [Table("notification_types")]
    public class NotificationType
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("HEADER_AR")]
        [Required]
        public string strHeaderAr { get; set; }

        [Column("HEADER_EN")]
        [Required]
        public string strHeaderEn { get; set; }

        [Column("BODY_AR")]
        [Required]
        public string strBodyAr { get; set; }

        [Column("BODY_EN")]
        [Required]
        public string strBodyEn { get; set; }

        [Column("CREATED_BY")]
        [Required]
        [ForeignKey("CreatedBy")]
        public int intCreatedBy { get; set; }
        ApplicationUser CreatedBy { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; } = DateTime.UtcNow;

        [Column("LAST_MODIFIED_BY")]
        [Required]
        [ForeignKey("ModifiedBy")]
        public int intLastModifiedBy { get; set; }
        ApplicationUser ModifiedBy { get; set; }

        [Column("DATE_LAST_MODIFIED")]
        [AllowNull]
        public DateTime dtmDateLastModified { get; set; }

        [Column("IS_DELETED")]
        public Boolean blnIsDeleted { get; set; }
    }
}
