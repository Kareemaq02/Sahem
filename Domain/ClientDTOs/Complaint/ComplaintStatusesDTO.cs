namespace Domain.ClientDTOs.Complaint
{
    public class ComplaintStatusesDTO
    {
        public int intComplaintId { get; set; }
        public int intComplaintStatusId { get; set; }
        public string strStatusName { get; set; }
        public string strStatusNameAr { get; set; }
        public DateTime dtmTrans { get; set; }
    }
}
