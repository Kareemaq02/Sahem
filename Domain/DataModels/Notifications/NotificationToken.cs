using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Domain.DataModels.Notifications
{
    [Table("notification_tokens")]
    public class NotificationToken
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("USER_ID")]
        [ForeignKey("User")]
        public int intUserId { get; set; }
        ApplicationUser User { get; set; }

        [Column("TOKEN")]
        public string strToken { get; set; }
    }
}
