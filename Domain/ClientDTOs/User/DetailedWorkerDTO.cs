namespace Domain.ClientDTOs.User
{
    public class DetailedWorkerDTO
    {
        public int intId { get; set; }
        public string strUsername { get; set; }
        public string strFirstName { get; set; }
        public string strLastName { get; set; }
        public string strFirstNameAr { get; set; }
        public string strLastNameAr { get; set; }
        public bool boolIsVerified { get; set; }
        public bool boolIsActive { get; set; }
        public bool boolIsBlacklisted { get; set; }
        public string strPhoneNumber { get; set; }
        public string strNationalId { get; set; }
        public string strNationalIdNumber { get; set; }
        public string strPassportNumber { get; set; }
        public string strRegistrationNumber { get; set; }
        public int intCompletedTasksCount { get; set; }

    }
}
