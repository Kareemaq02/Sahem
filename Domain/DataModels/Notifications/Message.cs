using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Notifications
{
    [Table("messages")]
    public class Message
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("ADMIN_ID")]
        [ForeignKey("Admin")]
        public int intAdminId { get; set; }
        ApplicationUser Admin { get; set; }

        [Column("USER_ID")]
        [ForeignKey("User")]
        public int intUserId { get; set; }
        ApplicationUser User { get; set; }

        [Column("HEADER")]
        [Required]
        public string strHeader { get; set; }

        [Column("BODY")]
        [Required]
        public string strBody { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; } = DateTime.UtcNow;
    }
}
