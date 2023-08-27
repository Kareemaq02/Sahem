using Domain.DataModels.User;
using Domain.Resources;
using Microsoft.AspNetCore.Identity;

namespace Persistence
{
    public class Seed
    {
        // Seed file Settings
        private static readonly int _admins = 14;
        private static readonly int _leaders = 32;
        private static readonly int _workers = 87;
        private static readonly int _citizens = 416;
        private static readonly int _complaints = 1322;
        private static readonly int _tasks = 781;

        public static async Task SeedData(
            DataContext context,
            UserManager<ApplicationUser> userManager
        )
        {
            using var transaction = await context.Database.BeginTransactionAsync();
            try
            {
                if (!userManager.Users.Any())
                {
                    int typeAdmin = 0,
                        typeWorker = 0,
                        typeLeader = 0,
                        typeUser = 0;

                    if (!context.UserTypes.Any())
                    {
                        var typeAdminEntity = await context.UserTypes.AddAsync(
                            new UserType { strName = ConstantsDB.UserTypes.Admin }
                        );

                        var typeWorkerEntity = await context.UserTypes.AddAsync(
                            new UserType { strName = ConstantsDB.UserTypes.Worker }
                        );

                        var typeLeaderEntity = await context.UserTypes.AddAsync(
                            new UserType { strName = ConstantsDB.UserTypes.Leader }
                        );

                        var typeUserEntity = await context.UserTypes.AddAsync(
                            new UserType { strName = ConstantsDB.UserTypes.User }
                        );

                        await context.SaveChangesAsync();

                        // await saving to get valid IDs otherwise you'll get a zero which violates the Foreign key constraint
                        typeAdmin = typeAdminEntity.Entity.intId;
                        typeWorker = typeWorkerEntity.Entity.intId;
                        typeLeader = typeLeaderEntity.Entity.intId;
                        typeUser = typeUserEntity.Entity.intId;
                    }

                    await SeedDefaults.CreateDefaultUsers(
                        context,
                        userManager,
                        typeAdmin,
                        typeWorker,
                        typeLeader,
                        typeUser
                    );

                    for (int i = 0; i < _citizens; i++)
                    {
                        await SeedUser.SeedUsers(context, userManager, typeUser, i);
                    }
                    for (int i = 0; i < _workers; i++)
                    {
                        await SeedUser.SeedUsers(context, userManager, typeWorker, i);
                    }
                    for (int i = 0; i < _leaders; i++)
                    {
                        await SeedUser.SeedUsers(context, userManager, typeLeader, i);
                    }
                    for (int i = 0; i < _admins; i++)
                    {
                        await SeedUser.SeedUsers(context, userManager, typeAdmin, i);
                    }
                }

                if (!context.Complaints.Any())
                {
                    await SeedDefaults.CreateComplaintLookUpTables(context);
                    await context.SaveChangesAsync();

                    for (int i = 0; i < _complaints; i++)
                    {
                        await SeedComplaint.SeedComplaints(context);
                    }
                }

                if (!context.Tasks.Any())
                {
                    await SeedDefaults.CreateTaskLookUpTables(context);
                    await context.SaveChangesAsync();

                    for (int i = 0; i < _tasks; i++)
                    {
                        await SeedTask.SeedTasks(context);
                    }
                }

                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
            }
        }
    }
}
