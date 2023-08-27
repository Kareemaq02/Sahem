using Domain.DataModels.Complaints;
using Domain.DataModels.Intersections;

namespace Persistence
{
    public class SeedComplaint
    {
        public static async Task SeedComplaints(DataContext context)
        {
            Random random = new Random();
            var userType = context.UserTypes.Where(q => q.strName == "user").FirstOrDefault();
            var usersCount = context.Users.Where(q => q.intUserTypeId == userType.intId).Count();
            var complaintsTypesCount = context.ComplaintTypes.Count();

            var userRand = random.Next(1, usersCount + 1);
            var complaintRand = random.Next(1, complaintsTypesCount + 1);

            DateTime startDate = new DateTime(2022, 4, 14);
            int rangeDate = (DateTime.Today - startDate).Days;

            var user = context.Users
                .Where(q => q.intUserTypeId == userType.intId)
                .OrderBy(q => q.Id)
                .Skip(userRand - 1)
                .Take(1)
                .FirstOrDefault();

            var complaintType = context.ComplaintTypes
                .OrderBy(q => q.intId)
                .Skip(complaintRand - 1)
                .Take(1)
                .FirstOrDefault();

            DateTime dateCreated = startDate.AddDays(random.Next(rangeDate));
            DateTime dateReminded = startDate.AddDays(random.Next(rangeDate));

            var complaint = new Complaint
            {
                intUserID = user.Id,
                intTypeId = complaintType.intId,
                intStatusId = 1,
                strComment = "",
                intReminder = 1,
                intPrivacyId = 2,
                dtmDateLastModified = dateCreated,
                dtmDateLastReminded = dateReminded,
                intLastModifiedBy = 1,
                dtmDateCreated = dateCreated,
                intRegionId = 1,
            };

            var complaintEntity = await context.Complaints.AddAsync(complaint);
            await context.SaveChangesAsync();
            await context.ComplaintAttachments.AddAsync(
                CreateComplaintAttachment(complaintEntity.Entity.intId, dateCreated)
            );
            await context.SaveChangesAsync();
        }

        private static ComplaintAttachment CreateComplaintAttachment(
            int complaintId,
            DateTime dateCreated
        )
        {
            return new ComplaintAttachment
            {
                intComplaintId = complaintId,
                strMediaRef = @"C:\Fake\Path\Files\test.jpg",
                decLat = (decimal)GetRandomLat(),
                decLng = (decimal)GetRandomLng(),
                blnIsVideo = false,
                dtmDateCreated = dateCreated,
            };
        }

        public static double GetRandomLat()
        {
            // Amman's latitude ranges from 31.9564° N to 31.9864° N
            Random random = new Random();
            return random.NextDouble() * 0.03 + 31.9564;
        }

        public static double GetRandomLng()
        {
            // Amman's longitude ranges from 35.8570° E to 35.9249° E
            Random random = new Random();
            return random.NextDouble() * 0.0679 + 35.8570;
        }
    }
}
