namespace Domain.ClientDTOs.User
{
    public class CitizenDTO
    {
        public int intId { get; set; }
        public string strUsername { get; set; }
        public string strFirstName { get; set; }
        public string strLastName { get; set; }
        public bool boolIsVerified { get; set; }
        public bool boolIsActive { get; set; }
        public bool boolIsBlacklisted { get; set; }

    }
}
