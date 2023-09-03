using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Team_touches : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(name: "FK_tasks_users_LEADER_ID", table: "tasks");

            migrationBuilder.DropColumn(name: "IS_LEADER", table: "team_members");

            // FAULTY GENERATED SQL
            //migrationBuilder.RenameColumn(
            //    name: "LEADER_ID",
            //    table: "tasks",
            //    newName: "TEAM_ID");

            // MANUAL SQL
            migrationBuilder.Sql("ALTER TABLE tasks RENAME COLUMN LEADER_ID TO TEAM_ID;");

            migrationBuilder.RenameIndex(
                name: "IX_tasks_LEADER_ID",
                table: "tasks",
                newName: "IX_tasks_TEAM_ID"
            );

            migrationBuilder.AddColumn<int>(
                name: "WORKER_ID",
                table: "worker_vacations",
                type: "int",
                nullable: false,
                defaultValue: 0
            );

            migrationBuilder.AddColumn<int>(
                name: "LEADER_ID",
                table: "teams",
                type: "int",
                nullable: false,
                defaultValue: 0
            );

            migrationBuilder.CreateIndex(
                name: "IX_worker_vacations_WORKER_ID",
                table: "worker_vacations",
                column: "WORKER_ID"
            );

            migrationBuilder.CreateIndex(
                name: "IX_teams_LEADER_ID",
                table: "teams",
                column: "LEADER_ID"
            );

            migrationBuilder.AddForeignKey(
                name: "FK_tasks_teams_TEAM_ID",
                table: "tasks",
                column: "TEAM_ID",
                principalTable: "teams",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_teams_users_LEADER_ID",
                table: "teams",
                column: "LEADER_ID",
                principalTable: "users",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );

            migrationBuilder.AddForeignKey(
                name: "FK_worker_vacations_users_WORKER_ID",
                table: "worker_vacations",
                column: "WORKER_ID",
                principalTable: "users",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(name: "FK_tasks_teams_TEAM_ID", table: "tasks");

            migrationBuilder.DropForeignKey(name: "FK_teams_users_LEADER_ID", table: "teams");

            migrationBuilder.DropForeignKey(
                name: "FK_worker_vacations_users_WORKER_ID",
                table: "worker_vacations"
            );

            migrationBuilder.DropIndex(
                name: "IX_worker_vacations_WORKER_ID",
                table: "worker_vacations"
            );

            migrationBuilder.DropIndex(name: "IX_teams_LEADER_ID", table: "teams");

            migrationBuilder.DropColumn(name: "WORKER_ID", table: "worker_vacations");

            migrationBuilder.DropColumn(name: "LEADER_ID", table: "teams");

            migrationBuilder.RenameColumn(name: "TEAM_ID", table: "tasks", newName: "LEADER_ID");

            migrationBuilder.RenameIndex(
                name: "IX_tasks_TEAM_ID",
                table: "tasks",
                newName: "IX_tasks_LEADER_ID"
            );

            migrationBuilder.AddColumn<bool>(
                name: "IS_LEADER",
                table: "team_members",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false
            );

            migrationBuilder.AddForeignKey(
                name: "FK_tasks_users_LEADER_ID",
                table: "tasks",
                column: "LEADER_ID",
                principalTable: "users",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );
        }
    }
}
