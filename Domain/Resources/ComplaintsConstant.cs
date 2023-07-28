namespace Domain.Resources
{
    public static class ComplaintsConstant
    {
        public enum complaintStatus
        {
            pending = 1,
            rejected = 2,
            approved = 3,
            Scheduled = 4,
            inProgress = 5,
            waitingEvaluation = 6,
            completed = 7,
            refiled = 8
        }

        public enum complaintPrivacy
        {
            privacyPrivate = 1,
            privacyPublic = 2,
            privacyAny = 3,
        }
    }
}
