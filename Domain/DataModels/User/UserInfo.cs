using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.User
{
    [Table("users_info")]
    public class UserInfo
    {
        [Column("ID")]
        [Key]
        public int intId { get; set; }

        [Column("FIRST_NAME")]
        public string strFirstName { get; set; }

        [Column("LAST_NAME")]
        public string strLastName { get; set; }

        [Column("FIRST_NAME_AR")]
        public string strFirstNameAr { get; set; }

        [Column("LAST_NAME_AR")]
        public string strLastNameAr { get; set; }

        [Column("PHONE_NUMBER")]
        public string strPhoneNumber { get; set; }

        [Column("NATIONAL_ID")]
        public string strNationalId { get; set; }

        [Column("PASSPORT_NUMBER")]
        public string strPassportNumber { get; set; }

        [Column("REGISTRATION_NUMBER")]
        public string strRegistrationNumber { get; set; }

        [Column("NATIONAL_ID_NUMBER")]
        public string strNationalIdNumber { get; set; }

        // Relations
        public ApplicationUser User { get; set; }
    }
}
