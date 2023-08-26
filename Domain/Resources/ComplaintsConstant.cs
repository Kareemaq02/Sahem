namespace Domain.Resources
{
    public static class ComplaintsConstant
    {
        public enum complaintStatus
        {
            pending = 1,
            rejected = 2,
            Scheduled = 3,
            inProgress = 4,
            waitingEvaluation = 5,
            completed = 6,
            refiled = 7
        }

        public enum complaintPrivacy
        {
            privacyPrivate = 1,
            privacyPublic = 2,
            privacyAny = 3,
        }
    }
}
