using Domain.DataModels.LookUps;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("teams")]
    public class Team
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("ADMIN_ID")]
        [ForeignKey("Admin")]
        public int intAdminId { get; set; }
        public ApplicationUser Admin { get; set; }

        [Column("LEADER_ID")]
        [ForeignKey("Leader")]
        public int intLeaderId { get; set; }
        public ApplicationUser Leader { get; set; }

        [Column("DEPARTMENT_ID")]
        [ForeignKey("department")]
        public int intDepartmentId { get; set; }
        Department Department { get; set; }

        // Relations
        public ICollection<TeamMembers> Workers { get; set; }
    }
}
