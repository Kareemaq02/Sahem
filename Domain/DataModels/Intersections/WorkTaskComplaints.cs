using Domain.DataModels.Complaints;
using Domain.DataModels.Tasks;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("tasks_complaints")]
    public class WorkTaskComplaints
    {
        [Column("TASK_ID")]
        [ForeignKey("Task")]
        public int intTaskId { get; set; }
        public WorkTask Task { get; set; }

        [Column("COMPLAINT_ID")]
        [ForeignKey("Complaint")]
        public int intComplaintId { get; set; }
        public Complaint Complaint { get; set; }
    }
}
