using Domain.DataModels.Intersections;
using Domain.DataModels.Tasks;

namespace Persistence
{
    public class SeedTask
    {
        public static async Task SeedTasks(DataContext context)
        {
            Random random = new Random();
            var adminType = context.UserTypes.Where(q => q.strName == "admin").FirstOrDefault();
            var adminsCount = context.Users.Where(q => q.intUserTypeId == adminType.intId).Count();
            var TaskTypesCount = context.TaskTypes.Count();

            var adminRand = random.Next(1, adminsCount + 1);
            var taskRand = random.Next(1, TaskTypesCount + 1);

            DateTime startDate = new DateTime(2022, 4, 14);
            int rangeDate = (DateTime.Today - startDate).Days;

            var admin = context.Users
                .Where(q => q.intUserTypeId == adminType.intId)
                .OrderBy(q => q.Id)
                .Skip(adminRand - 1)
                .Take(1)
                .FirstOrDefault();

            var taskType = context.TaskTypes
                .OrderBy(q => q.intId)
                .Skip(taskRand - 1)
                .Take(1)
                .FirstOrDefault();

            DateTime dateCreated = startDate.AddDays(random.Next(rangeDate));
            DateTime datelastModified = startDate.AddDays(random.Next(rangeDate));

            var task = new WorkTask
            {
                intAdminId = admin.Id,
                intStatusId = 1,
                intTypeId = taskType.intId,
                decCost = (decimal)(random.NextDouble() * 12654 - 89) + 89,
                intTeamId = 1,
                dtmDateScheduled = dateCreated,
                dtmDateActivated = dateCreated,
                dtmDateDeadline = datelastModified,
                dtmDateFinished = datelastModified,
                dtmDateLastModified = datelastModified,
                dtmDateCreated = dateCreated,
                strComment = "",
                blnIsDeleted = false,
                decRating = 0,
                intLastModifiedBy = 1,
            };

            var taskEntity = await context.Tasks.AddAsync(task);
            await context.SaveChangesAsync();

            var complaintsCount = context.Complaints.Count();
            var complaintRand = random.Next(1, complaintsCount + 1);

            var complaint = context.Complaints
                .OrderBy(q => q.intId)
                .Skip(complaintRand - 1)
                .Take(1)
                .FirstOrDefault();

            await context.TasksComplaints.AddAsync(
                new WorkTaskComplaints
                {
                    intTaskId = taskEntity.Entity.intId,
                    intComplaintId = complaint.intId
                }
            );
            await context.SaveChangesAsync();
        }
    }
}
