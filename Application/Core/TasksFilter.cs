namespace Application.Core
{
    public class TasksFilter : PagingParams
    {
        public List<int> lstTaskStatusIds { get; set; } = new List<int>();
        public List<int> lstTaskTypeIds { get; set; } = new List<int>();
        public List<int> lstWorkersIds { get; set; } = new List<int>();
        public string strAdmin { get; set; }
        public int intLeaderId { get; set; }
        public DateTime dtmDateScheduled { get; set; } = DateTime.MinValue;
        public DateTime dtmDateActivated { get; set; } = DateTime.MinValue;
        public DateTime dtmDateFinished { get; set; } = DateTime.MinValue;
        public DateTime dtmDateDeadline { get; set; } = DateTime.MinValue;
    }
}
