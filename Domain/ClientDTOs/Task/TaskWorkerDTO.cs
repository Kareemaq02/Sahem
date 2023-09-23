namespace Domain.ClientDTOs.User
{
    public class TaskWorkerDTO
    {
        public int intId { get; set; }
        public string strFirstName { get; set; }
        public string strLastName { get; set; }
        public string strFirstNameAr { get; set; }
        public string strLastNameAr { get; set; }
        public bool isLeader { get; set; }
        public decimal decRating { get; set; } = 0.00M;

    }
}
