using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class merged_attachments : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "tasks_attachments");

            migrationBuilder.AddColumn<bool>(
                name: "IS_FROM_WORKER",
                table: "complaints_attachments",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IS_FROM_WORKER",
                table: "complaints_attachments");

            migrationBuilder.CreateTable(
                name: "tasks_attachments",
                columns: table => new
                {
                    TASK_ID = table.Column<int>(type: "int", nullable: false),
                    MEDIA_REF = table.Column<string>(type: "varchar(255)", nullable: false),
                    IS_VIDEO = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    DATE_CREATED = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    CREATED_BY = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tasks_attachments", x => new { x.TASK_ID, x.MEDIA_REF });
                    table.ForeignKey(
                        name: "FK_tasks_attachments_tasks_TASK_ID",
                        column: x => x.TASK_ID,
                        principalTable: "tasks",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");
        }
    }
}
