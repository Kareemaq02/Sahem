using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Complaints
{
    [Table("worker_vacations")]
    public class WorkerVacation
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("WORKER_ID")]
        [ForeignKey("Worker")]
        public int intWorkerId { get; set; }
        public ApplicationUser Worker { get; set; }

        [Column("START_DATE")]
        public DateTime dtmStartDate { get; set; }

        [Column("END_DATE")]
        public DateTime dtmEndDate { get; set; }
    }
}
