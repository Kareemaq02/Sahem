using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using Domain.Resources;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using Persistence;

namespace Application.Seed
{
    public class Seed
    {
        // Seed file Settings
        private readonly int _admins;
        private readonly int _leaders;
        private readonly int _workers;
        private readonly int _citizens;

        private readonly int _complaints;
        private readonly int _tasks;

        private readonly DataContext _context;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IServiceProvider _serviceProvider;

        public Seed(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            IMediator mediator,
            IServiceProvider serviceProvider
        )
        {
            _context = context;
            _userManager = userManager;
            _serviceProvider = serviceProvider;

            _admins = 4;
            _leaders = _admins * 2;
            _workers = _leaders * 4;
            _citizens = _workers * 2;

            _complaints = _citizens * 3;
            _tasks = _complaints / 2;
        }

        public async Task SeedData()
        {
            await SeedDefaults.CreateComplaintLookUpTables(_context);
            await SeedDefaults.CreateTaskLookUpTables(_context);

            if (!_userManager.Users.Any())
            {
                int typeAdmin = 0,
                    typeWorker = 0,
                    typeLeader = 0,
                    typeUser = 0;

                if (!_context.UserTypes.Any())
                {
                    var typeAdminEntity = await _context.UserTypes.AddAsync(
                        new UserType { strName = ConstantsDB.UserTypes.Admin }
                    );

                    var typeWorkerEntity = await _context.UserTypes.AddAsync(
                        new UserType { strName = ConstantsDB.UserTypes.Worker }
                    );

                    var typeLeaderEntity = await _context.UserTypes.AddAsync(
                        new UserType { strName = ConstantsDB.UserTypes.Leader }
                    );

                    var typeUserEntity = await _context.UserTypes.AddAsync(
                        new UserType { strName = ConstantsDB.UserTypes.User }
                    );

                    await _context.SaveChangesAsync();

                    // await saving to get valid IDs otherwise you'll get a zero which violates the Foreign key constraint
                    typeAdmin = typeAdminEntity.Entity.intId;
                    typeWorker = typeWorkerEntity.Entity.intId;
                    typeLeader = typeLeaderEntity.Entity.intId;
                    typeUser = typeUserEntity.Entity.intId;
                }

                await SeedDefaults.CreateDefaultUsers(
                    _context,
                    _userManager,
                    typeAdmin,
                    typeWorker,
                    typeLeader,
                    typeUser
                );

                await SeedDefaults.CreateDepartmentAsync("تجريبي", "test", _context);
                await SeedDefaults.CreateDepartmentAsync("1تجريبي", "test1", _context);
                await SeedDefaults.CreateDepartmentAsync("2تجريبي", "test2", _context);

                await _context.DepartmentUsers.AddAsync(
                    new DepartmentUsers { intDepartmentId = 1, intUserId = 1 }
                );
                await _context.SaveChangesAsync();

                for (int i = 0; i < _citizens; i++)
                {
                    await SeedUser.SeedUsers(_context, _userManager, typeUser, i);
                }
                for (int i = 0; i < _workers; i++)
                {
                    await SeedUser.SeedUsers(_context, _userManager, typeWorker, i);
                }
                for (int i = 0; i < _leaders; i++)
                {
                    await SeedUser.SeedUsers(_context, _userManager, typeLeader, i);
                }
                for (int i = 0; i < _admins; i++)
                {
                    await SeedUser.SeedUsers(_context, _userManager, typeAdmin, i);
                }
            }

            if (!_context.NotificationTypes.Any())
            {
                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم رفض شكوتك رقم ",
                    "Your complaint with the number",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم إضافتك إلى قسم ال",
                    "You have been added to the",
                    "يرحب بك",
                    "welcomes you",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم تحديث شكواك إلى الحالة 'قيد العمل'. شكواك قيد المراجعة من قبل فريقنا، وسوف نقوم بإعلامك بأي تحديثات جديدة. شكرا لك على صبرك.",
                    "Your complaint has been updated to 'In Progress' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم انجاز بلاغك. شكرا لك على صبرك.",
                    "Your complaint has been completed. Thank you for your patience.",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم تحديث شكواك إلى الحالة 'قيد الانتظار'. شكواك قيد المراجعة من قبل فريقنا، وسوف نقوم بإعلامك بأي تحديثات جديدة. شكرا لك على صبرك.",
                    "Your complaint has been updated to 'Pending' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "لقد تم تفعيل إحدى مهامك",
                    "One of your tasks has been activated",
                    "تم تفعيل المهمة ذات الرقم",
                    "Task with the number",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم حذف إحدى مهامك",
                    "One of your tasks has been deleted",
                    "تم حذف المهمة ذات الرقم",
                    "The task with the number #12 has been deleted",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم تحديث شكواك إلى الحالة 'مجدول'. شكواك قيد المراجعة من قبل فريقنا، وسوف نقوم بإعلامك بأي تحديثات جديدة. شكرا لك على صبرك.",
                    "Your complaint has been updated to 'Scheduled' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تعيين مهمة لفريقك",
                    "A task has been assigned to your team",
                    "يجب تنفيذ المهمة قبل التاريخ التالي:",
                    "The task is to be done before the following date:",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "تم تغيير حالة شكوتك",
                    "Your complaint status has been changed",
                    "تم تحديث شكواك إلى الحالة 'انتظار التقييم'. شكواك قيد المراجعة من قبل فريقنا، وسوف نقوم بإعلامك بأي تحديثات جديدة. شكرا لك على صبرك.",
                    "Your complaint has been updated to 'Waiting Evaluation' status. Your complaint is under review by our team, and we will notify you of any new updates. Thank you for your patience.",
                    _context
                );

                await SeedDefaults.CreateNotificationsTypeAsync(
                    "لقد تمت إضافتك إلى فريق",
                    "You have been added to a team",
                    "يرحب بك",
                    "welcomes you",
                    _context
                );
            }

            if (!_context.Teams.Any())
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
                    var context = scope.ServiceProvider.GetRequiredService<DataContext>();
                    SeedTeams.Seed(context, mediator);
                }
            }

            if (!_context.Complaints.Any())
            {
                for (int i = 0; i < _complaints; i++)
                {
                    using (var scope = _serviceProvider.CreateScope())
                    {
                        var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
                        var context = scope.ServiceProvider.GetRequiredService<DataContext>();
                        await SeedComplaint.Seed(context, mediator);
                    }
                }
                using (var scope = _serviceProvider.CreateScope())
                {
                    var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
                    var context = scope.ServiceProvider.GetRequiredService<DataContext>();
                    await SeedComplaint.Reject(context, mediator);
                }

                using (var scope = _serviceProvider.CreateScope())
                {
                    var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
                    var context = scope.ServiceProvider.GetRequiredService<DataContext>();
                    await SeedComplaint.Vote(context, mediator);
                }
            }

            if (!_context.Tasks.Any())
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();

                    await SeedTask.Seed(mediator, _tasks);
                }
            }
        }
    }
}
