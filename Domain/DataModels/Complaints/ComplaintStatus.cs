using Domain.DataModels.Intersections;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Complaints
{
    [Table("complaints_status")]
    public class ComplaintStatus
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("NAME")]
        [Required]
        public string strName { get; set; }

        [Column("NAME_AR")]
        [Required]
        public string strNameAr { get; set; }

        // Relations
        public ICollection<ComplaintsStatuses> Complaints { get; set; }
    }
}
