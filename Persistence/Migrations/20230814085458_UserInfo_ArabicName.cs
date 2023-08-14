using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UserInfo_ArabicName : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "FIRST_NAME_AR",
                table: "users_info",
                type: "longtext",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LAST_NAME_AR",
                table: "users_info",
                type: "longtext",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FIRST_NAME_AR",
                table: "users_info");

            migrationBuilder.DropColumn(
                name: "LAST_NAME_AR",
                table: "users_info");
        }
    }
}
