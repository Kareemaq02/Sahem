using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Complaints
{
    [Table("complaints_privacy")]
    public class ComplaintPrivacy
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("NAME_AR")]
        [Required]
        public string strNameAr { get; set; }

        [Column("NAME_EN")]
        [Required]
        public string strNameEn { get; set; }
    }
}
