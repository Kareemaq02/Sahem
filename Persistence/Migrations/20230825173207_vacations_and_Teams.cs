using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class vacations_and_Teams : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "tasks_members");

            migrationBuilder.AddColumn<int>(
                name: "LEADER_ID",
                table: "tasks",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "teams",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    ADMIN_ID = table.Column<int>(type: "int", nullable: false),
                    DEPARTMENT_ID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_teams", x => x.ID);
                    table.ForeignKey(
                        name: "FK_teams_users_ADMIN_ID",
                        column: x => x.ADMIN_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "worker_vacations",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    START_DATE = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    END_DATE = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_worker_vacations", x => x.ID);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "team_members",
                columns: table => new
                {
                    WORKER_ID = table.Column<int>(type: "int", nullable: false),
                    TEAM_ID = table.Column<int>(type: "int", nullable: false),
                    IS_LEADER = table.Column<bool>(type: "tinyint(1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_team_members", x => new { x.WORKER_ID, x.TEAM_ID });
                    table.ForeignKey(
                        name: "FK_team_members_teams_TEAM_ID",
                        column: x => x.TEAM_ID,
                        principalTable: "teams",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_team_members_users_WORKER_ID",
                        column: x => x.WORKER_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_tasks_LEADER_ID",
                table: "tasks",
                column: "LEADER_ID");

            migrationBuilder.CreateIndex(
                name: "IX_team_members_TEAM_ID",
                table: "team_members",
                column: "TEAM_ID");

            migrationBuilder.CreateIndex(
                name: "IX_teams_ADMIN_ID",
                table: "teams",
                column: "ADMIN_ID");

            migrationBuilder.AddForeignKey(
                name: "FK_tasks_users_LEADER_ID",
                table: "tasks",
                column: "LEADER_ID",
                principalTable: "users",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_tasks_users_LEADER_ID",
                table: "tasks");

            migrationBuilder.DropTable(
                name: "team_members");

            migrationBuilder.DropTable(
                name: "worker_vacations");

            migrationBuilder.DropTable(
                name: "teams");

            migrationBuilder.DropIndex(
                name: "IX_tasks_LEADER_ID",
                table: "tasks");

            migrationBuilder.DropColumn(
                name: "LEADER_ID",
                table: "tasks");

            migrationBuilder.CreateTable(
                name: "tasks_members",
                columns: table => new
                {
                    USER_ID = table.Column<int>(type: "int", nullable: false),
                    TASK_ID = table.Column<int>(type: "int", nullable: false),
                    IS_LEADER = table.Column<bool>(type: "tinyint(1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tasks_members", x => new { x.USER_ID, x.TASK_ID });
                    table.ForeignKey(
                        name: "FK_tasks_members_tasks_TASK_ID",
                        column: x => x.TASK_ID,
                        principalTable: "tasks",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_tasks_members_users_USER_ID",
                        column: x => x.USER_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_tasks_members_TASK_ID",
                table: "tasks_members",
                column: "TASK_ID");
        }
    }
}
