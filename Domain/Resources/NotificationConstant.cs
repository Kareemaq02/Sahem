namespace Domain.Resources
{
    public static class NotificationConstant
    {
        public enum NotificationType
        {
            rejectedComplaintNotification = 1,
            workerAddedToDepartmentNotification = 2,
            completedComplaintNotification = 3,
            complaintStatusChangeNotification = 4,
            taskStatusChangeNotification = 5,
            taskDeletionNotification = 6,
            taskCreationNotification = 7,
            workerAddedToTeamNotification = 9
        }

    }
}
