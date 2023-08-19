using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class arabic_status : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "NAME_AR",
                table: "tasks_status",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "NAME_AR",
                table: "complaints_status",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NAME_AR",
                table: "tasks_status");

            migrationBuilder.DropColumn(
                name: "NAME_AR",
                table: "complaints_status");
        }
    }
}
