namespace Domain.Resources
{
    public static class ConstantsDB
    {
        public static class UserTypes
        {
            public const string Admin = "admin";
            public const string Worker = "worker";
            public const string Leader = "teamleader";
            public const string User = "user";
        }

        public static class ComplaintPrivacyTypes
        {
            public const string PrivateEn = "private";
            public const string PublicEN = "public";
            public const string AnyEN = "any";
            public const string PrivateAr = "خاص";
            public const string PublicAr = "عام";
            public const string AnyAr = "كل";
        }

        public static class ComplaintStatusTypes
        {
            public const string Pending = "pending";
            public const string Rejected = "rejected";
            public const string Approved = "approved";
            public const string Scheduled = "scheduled";
            public const string InProgress = "in progress";
            public const string WaitingEvaluation = "waiting evaluation";
            public const string Completed = "completed";
            public const string ReFiled = "re-filed";

            public const string PendingAr = "قيد الانتظار";
            public const string RejectedAr = "مرفوض";
            public const string ApprovedAr = "موافق عليه";
            public const string ScheduledAr = "مجدول";
            public const string InProgressAr = "قيد العمل";
            public const string WaitingEvaluationAr = "انتظار التقييم";
            public const string CompletedAr = "منجز";
            public const string ReFiledAr = "بلاغ معاد";
        }

        public static class TaskStatusTypes
        {
            public const string Inactive = "inactive";
            public const string InProgress = "in progress";
            public const string WaitingEvaluation = "waiting evaluation";
            public const string Failed = "failed";
            public const string Incomplete = "incomplete";
            public const string Completed = "completed";

            public const string InactiveAr = "غير مفعل";
            public const string InProgressAr = "قيد العمل";
            public const string WaitingEvaluationAr = "انتظار التقييم";
            public const string FailedAr = "فشل";
            public const string IncompleteAr = "غير مكتمل";
            public const string CompletedAr = "منجز";
        }

        public static class ComplaintTypes
        {
            public struct ComplaintType
            {
                public readonly string Ar;
                public readonly string En;

                public ComplaintType(string strAr, string strEn)
                {
                    Ar = strAr;
                    En = strEn;
                }
            };

            public readonly static ComplaintType WasteAccumulation =
                new("تراكم النفايات", "Waste accumulation");

            public readonly static ComplaintType ScatterWaste =
                new("مبعثرات حول الحاوية", "Scatter waste");

            public readonly static ComplaintType TreePruningWaste =
                new("مخلفات تقليم الاشجار", "Tree pruning waste");

            public readonly static ComplaintType CementSpeedBumps =
                new("مطبات اسمنتية عشوائية", "Random cement speed bumps");

            public readonly static ComplaintType ViolatingSpeedBumps =
                new("مطبات نظامية مخالفة", "Violating speed bumps");

            public readonly static ComplaintType WaterPools =
                new("تجمعات المياه(لا يوجد تصريف) ", "Water pools (no drainage)");

            public readonly static ComplaintType BrokenWaterPipe =
                new("خط مياه مكسور/معطل", "Broken/Non-functional water pipe");

            public readonly static ComplaintType StreetCracks =
                new("تصدعات في الشارع", "Street Cracks");

            public readonly static ComplaintType Potholes = new("حفر في الشارع", "Street potholes");

            public readonly static ComplaintType SideSafetyRails =
                new("سكك امان جانبية للشوارع", "Side safety rails");

            public readonly static ComplaintType MissingManholes =
                new("مناهل مفقودة", "Missing manholes");

            public readonly static ComplaintType LowerManholes =
                new("مناهل منخفضة عن مستوى الشارع", "Manholes lower than street level");

            public readonly static ComplaintType HigherManholes =
                new("مناهل مرتفعة عن مستوى الشارع", "Manholes higher than street level");

            public readonly static ComplaintType IllegalSigns =
                new("شواخص إعلانية غير قانونية", "Illegal advertising signs");

            public readonly static ComplaintType BrokenSigns =
                new("شواخص مرورية مكسوره", "Broken traffic signs");

            public readonly static ComplaintType BlockedSigns =
                new("شواخص مرورية محجوبة", "Blocked traffic signs");

            public readonly static ComplaintType StreetLightsOut =
                new("انارة الشوارع معطلة", "Street lights out");

            public readonly static ComplaintType BrokenWall =
                new("تكسر/تصدع جدار استنادي", "Broken/Cracked retaining wall");

            public readonly static ComplaintType BrokenPavement =
                new("تكسر اطراف/ارصفة", "Broken pavement");

            public readonly static ComplaintType Graffiti = new("رسومات", "Graffiti");

            public readonly static ComplaintType ConstructionWaste =
                new("مخلفات اعمال بناء", "Construction waste");

            public readonly static ComplaintType MaintenanceWaste =
                new("مخلفات اعمال صيانة", "Maintenance waste");
        }
    }
}
