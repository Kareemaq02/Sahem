using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using Domain.Resources;
using Microsoft.AspNetCore.Identity;

namespace Persistence
{
    public class Seed
    {
        // Seed file Settings
        private static readonly int _admins = 4;
        private static readonly int _leaders = _admins * 2;
        private static readonly int _workers = _leaders * 4;
        private static readonly int _citizens = _workers * 2;

        private static readonly int _complaints = 1322;
        private static readonly int _tasks = 6;

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

                    await SeedDefaults.CreateDepartmentAsync("تجريبي", "test", context);
                    await SeedDefaults.CreateDepartmentAsync("1تجريبي", "test1", context);
                    await SeedDefaults.CreateDepartmentAsync("2تجريبي", "test2", context);

                    await context.DepartmentUsers.AddAsync(
                        new DepartmentUsers { intDepartmentId = 1, intUserId = 1 }
                    );
                    await context.SaveChangesAsync();

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

                if (!context.Complaints.Any()) { }

                if (!context.Tasks.Any()) { }

                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
            }
        }
    }
}
