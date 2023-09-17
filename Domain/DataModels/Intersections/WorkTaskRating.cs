using Domain.DataModels.Tasks;
using Domain.DataModels.User;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.DataModels.Intersections
{
    [Table("tasks_ratings")]
    public class WorkTaskRating
    {
        [Column("TASK_ID")]
        [ForeignKey("Task")]
        public int intTaskId { get; set; }
        public WorkTask Task { get; set; }

        [Column("USER_ID")]
        [ForeignKey("User")]
        public int intUserId { get; set; }
        public ApplicationUser User { get; set; }

        [Column("RATING")]
        [Required]
        public decimal decRating { get; set; }
    }
}
