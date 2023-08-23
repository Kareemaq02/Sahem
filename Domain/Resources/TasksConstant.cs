namespace Domain.Resources
{
    public static class TasksConstant
    {
        public enum taskStatus
        {
            inactive = 1,
            inProgress = 2,
            waitingEvaluation = 3,
            failed = 4,
            incomplete = 5,
            completed = 6,
        }
        public enum taskType
        {
            multiType = 7
        }
    }
}
