using System.Diagnostics.CodeAnalysis;

namespace Domain.ClientDTOs.User
{
    public class UserUpdateDTO
    {
        [AllowNull]
        public string strNewUserName { get; set; }

        [AllowNull]
        public string strNewEmail { get; set; }

        [AllowNull]
        public string strNewPhoneNumber { get; set; }

        [AllowNull]
        public string strOldPassword { get; set; }

        [AllowNull]
        public string strNewPassword { get; set; }

        [AllowNull]
        public string strNewLocation { get; set; }
    }
}
