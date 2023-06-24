using Domain.DataModels.Complaints;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("complaints_statuses")]
    public class ComplaintsStatuses
    {
        [Column("COMPLAINT_ID")]
        [ForeignKey("Complaint")]
        public int intComplaintId { get; set; }
        public Complaint Complaint { get; set; }

        [ForeignKey("User")]
        [Column("STATUS_ID")]
        public int intStatusId { get; set; }
        public ComplaintStatus ComplaintStatus { get; set; }

        [Column("TRANS_DATE")]
        public DateTime dtmTransDate { get; set; }
    }
}
