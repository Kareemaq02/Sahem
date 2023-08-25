

namespace Domain.ClientDTOs.Task
{
    public class AddComplaintToExistingTaskDTO
    {
        public int taskId { get; set; }
        public List<int> lstComplaintsIds { get; set; }
    }
}
