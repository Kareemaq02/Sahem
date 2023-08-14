using Domain.DataModels.Complaints;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("complaints_attachments")]
    public class ComplaintAttachment
    {
        [Column("COMPLAINT_ID")]
        [ForeignKey("Complaint")]
        public int intComplaintId { get; set; }
        public Complaint Complaint { get; set; }

        [Column("MEDIA_REF")]
        [Required]
        public string strMediaRef { get; set; }

        [Column("LAT")]
        [Required]
        public decimal decLat { get; set; }

        [Column("LNG")]
        [Required]
        public decimal decLng { get; set; }

        [Column("CREATED_BY")]
        [Required]
        [ForeignKey("CreatedBy")]
        public int intCreatedBy { get; set; }
        ApplicationUser CreatedBy { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; }

        [Column("IS_VIDEO")]
        [Required]
        public Boolean blnIsVideo { get; set; }

        [Column("IS_FROM_WORKER")]
        [Required]
        public Boolean blnIsFromWorker { get; set; }
    }
}
