namespace Domain.Resources
{
    public static class NotificationConstant
    {
        public enum NotificationType
        {
            rejectedComplaintNotification = 1,
            workerAddedToDepartmentNotification = 2,
            inProgressComplaintNotification = 3,
            completedComplaintNotification = 4,
            pendingComplaintNotification = 5,
            activeTaskNotification = 6,
            taskDeletionNotification = 7,
            scheduledComplaintNotification = 8,
            taskCreationNotification = 9,
            waitingEvaluationComplaintNotification = 10,
            workerAddedToTeamNotification = 11,
        }

    }
}
