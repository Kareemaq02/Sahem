using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Domain.DataModels.Complaints;
using Domain.DataModels.Intersections;
using Domain.DataModels.Tasks;
using Domain.DataModels.LookUps;

namespace Persistence
{
    public class DataContext : IdentityDbContext<ApplicationUser, IdentityRole<int>, int>
    {
        public DataContext(DbContextOptions options)
            : base(options) { }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // Change table names
            builder.Entity<ApplicationUser>(b =>
            {
                b.ToTable("users");
                b.Property(e => e.Id).HasColumnName("ID");
                b.Property(e => e.UserName).HasColumnName("USER_NAME");
                b.Property(e => e.NormalizedUserName).HasColumnName("NORMALIZED_USER_NAME");
                b.Property(e => e.PhoneNumberConfirmed).HasColumnName("IS_CONFIRMED");
                b.Property(e => e.PasswordHash).HasColumnName("PASSWORD_HASH");
                b.Property(e => e.SecurityStamp).HasColumnName("SECURITY_STAMP");
                b.Property(e => e.ConcurrencyStamp).HasColumnName("CONCURRENCY_STAMP");
                b.Property(e => e.LockoutEnd).HasColumnName("LOCKOUT_END");
                b.Property(e => e.AccessFailedCount).HasColumnName("ACCESS_FAILED_COUNT");
            });

            builder.Entity<IdentityUserClaim<int>>(b =>
            {
                b.ToTable("users_claims");
                b.Property(e => e.Id).HasColumnName("ID");
                b.Property(e => e.UserId).HasColumnName("USER_ID");
                b.Property(e => e.ClaimType).HasColumnName("CLAIM_TYPE");
                b.Property(e => e.ClaimValue).HasColumnName("CLAIM_VALUE");
            });

            builder.Entity<IdentityRole<int>>(b =>
            {
                b.ToTable("roles");
                b.Property(e => e.Id).HasColumnName("ID");
                b.Property(e => e.Name).HasColumnName("NAME");
                b.Property(e => e.NormalizedName).HasColumnName("NORMALIZED_NAME");
                b.Property(e => e.ConcurrencyStamp).HasColumnName("CONCURRENCY_STAMP");
            });

            builder.Entity<IdentityRoleClaim<int>>(b =>
            {
                b.ToTable("roles_claims");
                b.Property(e => e.Id).HasColumnName("ID");
                b.Property(e => e.RoleId).HasColumnName("ROLE_ID");
                b.Property(e => e.ClaimType).HasColumnName("CLAIM_TYPE");
                b.Property(e => e.ClaimValue).HasColumnName("CLAIM_VALUE");
            });

            builder.Entity<IdentityUserRole<int>>(b =>
            {
                b.ToTable("users_roles");
                b.Property(e => e.UserId).HasColumnName("USER_ID");
                b.Property(e => e.RoleId).HasColumnName("ROLE_ID");
            });

            builder.Entity<IdentityUserLogin<int>>(b =>
            {
                b.ToTable("users_login");
                b.Property(e => e.UserId).HasColumnName("USER_ID");
                b.Property(e => e.LoginProvider).HasColumnName("LOGIN_PROVIDER");
                b.Property(e => e.ProviderKey).HasColumnName("PROVIDER_KEY");
                b.Property(e => e.ProviderDisplayName).HasColumnName("PROVIDER_DISPLAY_NAME");
            });

            builder.Entity<IdentityUserToken<int>>(b =>
            {
                b.ToTable("users_tokens");
                b.Property(e => e.UserId).HasColumnName("USER_ID");
                b.Property(e => e.LoginProvider).HasColumnName("LOGIN_PROVIDER");
                b.Property(e => e.Name).HasColumnName("NAME");
                b.Property(e => e.Value).HasColumnName("VALUE");
            });

            // Ignore properties
            builder
                .Entity<ApplicationUser>()
                .Ignore(q => q.Email)
                .Ignore(q => q.EmailConfirmed)
                .Ignore(q => q.PhoneNumber)
                .Ignore(q => q.NormalizedEmail)
                .Ignore(q => q.TwoFactorEnabled)
                .Ignore(q => q.LockoutEnabled);

            // Complaints Attchments Table
            builder.Entity<ComplaintAttachment>().Property(q => q.decLat).HasPrecision(8, 6);
            builder.Entity<ComplaintAttachment>().Property(q => q.decLng).HasPrecision(8, 6);

            // Complaint_Voters intersection table
            builder.Entity<ComplaintVoters>(
                q => q.HasKey(q => new { q.intUserId, q.intComplaintId })
            );
            builder
                .Entity<ComplaintVoters>()
                .HasOne(q => q.User)
                .WithMany(q => q.Complaints)
                .HasForeignKey(q => q.intUserId);
            builder
                .Entity<ComplaintVoters>()
                .HasOne(q => q.Complaint)
                .WithMany(q => q.Voters)
                .HasForeignKey(q => q.intComplaintId);

            // Complaint_Statuses intersection table
            builder.Entity<ComplaintsStatuses>(
                q => q.HasKey(q => new { q.intComplaintId, q.intStatusId })
            );
            builder
                .Entity<ComplaintsStatuses>()
                .HasOne(q => q.Complaint)
                .WithMany(q => q.Statuses)
                .HasForeignKey(q => q.intStatusId);
            builder
                .Entity<ComplaintsStatuses>()
                .HasOne(q => q.ComplaintStatus)
                .WithMany(q => q.Complaints)
                .HasForeignKey(q => q.intComplaintId);

            // Complaint_Attachment table
            builder.Entity<ComplaintAttachment>(
                q => q.HasKey(q => new { q.intComplaintId, q.strMediaRef })
            );

            // Tasks_Attachments table
            builder.Entity<WorkTaskAttachment>(
                q => q.HasKey(q => new { q.intTaskId, q.strMediaRef })
            );

            // Task_Members intersection table
            builder.Entity<WorkTaskMembers>(q => q.HasKey(q => new { q.intWorkerId, q.intTaskId }));
            builder
                .Entity<WorkTaskMembers>()
                .HasOne(q => q.Task)
                .WithMany(q => q.Workers)
                .HasForeignKey(q => q.intTaskId);
            builder
                .Entity<WorkTaskMembers>()
                .HasOne(q => q.Worker)
                .WithMany(q => q.Tasks)
                .HasForeignKey(q => q.intWorkerId);

            // Task_Complaint intersection table
            builder.Entity<WorkTaskComplaints>(
                q => q.HasKey(q => new { q.intTaskId, q.intComplaintId })
            );
            builder
                .Entity<WorkTaskComplaints>()
                .HasOne(q => q.Task)
                .WithMany(q => q.Complaints)
                .HasForeignKey(q => q.intTaskId);
            builder
                .Entity<WorkTaskComplaints>()
                .HasOne(q => q.Complaint)
                .WithMany(q => q.Tasks)
                .HasForeignKey(q => q.intComplaintId);

            // Department_Users intersection table
            builder.Entity<DepartmentUsers>(
                q => q.HasKey(q => new { q.intUserId, q.intDepartmentId })
            );
            builder
                .Entity<DepartmentUsers>()
                .HasOne(q => q.Department)
                .WithMany(q => q.Users)
                .HasForeignKey(q => q.intDepartmentId);
            builder
                .Entity<DepartmentUsers>()
                .HasOne(q => q.User)
                .WithMany(q => q.Departments)
                .HasForeignKey(q => q.intUserId);

            // Profession_Users intersection table
            builder.Entity<ProfessionUsers>(
                q => q.HasKey(q => new { q.intUserId, q.intProfessionId })
            );
            builder
                .Entity<ProfessionUsers>()
                .HasOne(q => q.Profession)
                .WithMany(q => q.Users)
                .HasForeignKey(q => q.intProfessionId);
            builder
                .Entity<ProfessionUsers>()
                .HasOne(q => q.User)
                .WithMany(q => q.Professions)
                .HasForeignKey(q => q.intUserId);
        }

        // Complaints DataSets
        public DbSet<Complaint> Complaints { get; set; }
        public DbSet<ComplaintStatus> ComplaintStatus { get; set; }
        public DbSet<ComplaintPrivacy> ComplaintPrivacy { get; set; }
        public DbSet<ComplaintType> ComplaintTypes { get; set; }
        public DbSet<ComplaintVoters> ComplaintVoters { get; set; }
        public DbSet<ComplaintAttachment> ComplaintAttachments { get; set; }
        public DbSet<ComplaintsStatuses> ComplaintsStatuses { get; set; }

        // Users DataSets
        public DbSet<ApplicationUser> ApplicationUsers { get; set; }
        public DbSet<UserInfo> UserInfos { get; set; }
        public DbSet<UserType> UserTypes { get; set; }

        // Tasks DataSets
        public DbSet<WorkTask> Tasks { get; set; }
        public DbSet<WorkTaskStatus> TaskStatus { get; set; }
        public DbSet<WorkTaskType> TaskTypes { get; set; }
        public DbSet<WorkTaskMembers> TaskMembers { get; set; }
        public DbSet<WorkTaskComplaints> TasksComplaints { get; set; }
        public DbSet<WorkTaskAttachment> TaskAttachments { get; set; }

        // Departments DataSets
        public DbSet<Department> Departments { get; set; }
        public DbSet<DepartmentUsers> DepartmentUsers { get; set; }

        // Professions DataSets
        public DbSet<Profession> Professions { get; set; }
        public DbSet<ProfessionUsers> ProfessionUsers { get; set; }
    }
}
