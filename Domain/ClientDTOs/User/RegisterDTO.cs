using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Domain.ClientDTOs.User
{
    public class RegisterDTO
    {
        [Required]
        [RegularExpression(
            @"^(?=.*[a-zA-Z])[a-zA-Z0-9._]{4,}$",
            ErrorMessage = "Username must be at least 4 characters long and no special characters."
        )]
        public string strUsername { get; set; }

        [Required]
        [RegularExpression(@"^\d{10}$", ErrorMessage = "Phone number must be 10 digits only.")]
        public string strPhonenumber { get; set; }

        [Required]
        //[RegularExpression(
        //    @"^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*\\W).{8,}$",
        //    ErrorMessage = "Password must have at least 8 characters, and contains at least one uppercase letter, one lowercase letter, one digit, and one non-alphanumeric character."
        //)]
        public string strPassword { get; set; }

        [Required]
        [RegularExpression(
            @"^[a-zA-Z]{2,}$",
            ErrorMessage = "Name must be longer than 2 characters."
        )]
        public string strFirstName { get; set; }

        [Required]
        [RegularExpression(
            @"^[a-zA-Z]{2,}$",
            ErrorMessage = "Name must be longer than 2 characters."
        )]
        public string strLastName { get; set; }

        [AllowNull]
        [RegularExpression(
            @"^[\u0600-\u06FF]{2,}$",
            ErrorMessage = "Name must be longer than 2 characters."
        )]
        public string strFirstNameAr { get; set; }

        [AllowNull]
        [RegularExpression(
            @"^[\u0600-\u06FF]{2,}$",
            ErrorMessage = "Name must be longer than 2 characters."
        )]
        public string strLastNameAr { get; set; }

        [AllowNull]
        [RegularExpression(
            @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
            ErrorMessage = "The Email field is not a valid e-mail address."
        )]
        public string strEmail { get; set; }

        [AllowNull]
        [RegularExpression(@"^\d{10}$", ErrorMessage = "National Id must be 10 digits only.")]
        public string strNationalId { get; set; }

        [AllowNull]
        public string strPassportNumber { get; set; }

        [AllowNull]
        [RegularExpression(
            @"^\d{3}/\d{3}$",
            ErrorMessage = "Invalid Registration Number, must be \"000/000\""
        )]
        public string strRegistrationNumber { get; set; }

        [AllowNull]
        [RegularExpression(
            @"^[A-Z]{3}\d{5}$",
            ErrorMessage = "Invalid Id number, must be \"AAA00000\""
        )]
        public string strNationalIdNumber { get; set; }
    }
}
