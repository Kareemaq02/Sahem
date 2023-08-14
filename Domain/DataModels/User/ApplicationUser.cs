using Domain.DataModels.Intersections;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.User
{
    public class ApplicationUser : IdentityUser<int>
    {
        // Add as ForeignKey to group table once created
        [Column("GROUP_ID")]
        public int intGroupId { get; set; }

        [Column("IS_VERIFIED")]
        public Boolean blnIsVerified { get; set; }

        [Column("IS_BLACKLISTED")]
        public Boolean blnIsBlacklisted { get; set; }

        [Column("IS_ACTIVE")]
        public Boolean blnIsActive { get; set; }

        [Column("USER_TYPE_ID")]
        [Required]
        [ForeignKey("UserType")]
        public int intUserTypeId { get; set; }
        public UserType UserType { get; set; }

        [Column("USER_INFO_ID")]
        [Required]
        [ForeignKey("UserInfo")]
        public int intUserInfoId { get; set; }
        public UserInfo UserInfo { get; set; }

        // Relations
        public ICollection<ComplaintVoters> Complaints { get; set; }
        public ICollection<ComplaintWatchers> ComplaintsWatched { get; set; }
        public ICollection<WorkTaskMembers> Tasks { get; set; }
        public ICollection<DepartmentUsers> Departments { get; set; }
        public ICollection<ProfessionUsers> Professions { get; set; }
    }
}
