﻿using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Notifications
{
    [Table("notifications")]
    public class Notification
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("TYPE_ID")]
        [ForeignKey("NotificationType")]
        public int intTypeId { get; set; }
        public NotificationType NotificationType { get; set; }

        [Column("USER_ID")]
        [ForeignKey("User")]
        public int intUserId { get; set; }
        ApplicationUser User { get; set; }

        [Column("DATE_CREATED")]
        [Required]
        public DateTime dtmDateCreated { get; set; } = DateTime.UtcNow;

        [Column("IS_READ")]
        [Required]
        public Boolean blnIsRead { get; set; }

        [Column("HEADER_AR")]
        [Required]
        public string strHeaderAr { get; set; }

        [Column("BODY_AR")]
        [Required]
        public string strBodyAr { get; set; }

        [Column("HEADER_EN")]
        [Required]
        public string strHeaderEn { get; set; }

        [Column("BODY_EN")]
        [Required]
        public string strBodyEn { get; set; }
    }
}
