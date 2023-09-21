using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class notifications_updated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "BODY_AR",
                table: "notifications",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "BODY_EN",
                table: "notifications",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "HEADER_AR",
                table: "notifications",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "HEADER_EN",
                table: "notifications",
                type: "longtext",
                nullable: false);

            migrationBuilder.CreateTable(
                name: "tasks_members_ratings",
                columns: table => new
                {
                    TASK_ID = table.Column<int>(type: "int", nullable: false),
                    MEMBER_ID = table.Column<int>(type: "int", nullable: false),
                    RATING = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tasks_members_ratings", x => new { x.MEMBER_ID, x.TASK_ID });
                    table.ForeignKey(
                        name: "FK_tasks_members_ratings_tasks_TASK_ID",
                        column: x => x.TASK_ID,
                        principalTable: "tasks",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_tasks_members_ratings_users_MEMBER_ID",
                        column: x => x.MEMBER_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "tasks_ratings",
                columns: table => new
                {
                    TASK_ID = table.Column<int>(type: "int", nullable: false),
                    USER_ID = table.Column<int>(type: "int", nullable: false),
                    RATING = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tasks_ratings", x => new { x.USER_ID, x.TASK_ID });
                    table.ForeignKey(
                        name: "FK_tasks_ratings_tasks_TASK_ID",
                        column: x => x.TASK_ID,
                        principalTable: "tasks",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_tasks_ratings_users_USER_ID",
                        column: x => x.USER_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_tasks_members_ratings_TASK_ID",
                table: "tasks_members_ratings",
                column: "TASK_ID");

            migrationBuilder.CreateIndex(
                name: "IX_tasks_ratings_TASK_ID",
                table: "tasks_ratings",
                column: "TASK_ID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "tasks_members_ratings");

            migrationBuilder.DropTable(
                name: "tasks_ratings");

            migrationBuilder.DropColumn(
                name: "BODY_AR",
                table: "notifications");

            migrationBuilder.DropColumn(
                name: "BODY_EN",
                table: "notifications");

            migrationBuilder.DropColumn(
                name: "HEADER_AR",
                table: "notifications");

            migrationBuilder.DropColumn(
                name: "HEADER_EN",
                table: "notifications");
        }
    }
}
