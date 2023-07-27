using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class PrivacyNames : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // FAULTY GENERATED SQL
            //migrationBuilder.RenameColumn(
            //    name: "NAME",
            //    table: "complaints_privacy",
            //    newName: "NAME_EN");

            // MANUAL SQL
            migrationBuilder.Sql("ALTER TABLE complaints_privacy RENAME COLUMN NAME TO NAME_EN;");

            migrationBuilder.AddColumn<string>(
                name: "NAME_AR",
                table: "complaints_privacy",
                type: "longtext",
                nullable: false
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(name: "NAME_AR", table: "complaints_privacy");

            migrationBuilder.RenameColumn(
                name: "NAME_EN",
                table: "complaints_privacy",
                newName: "NAME"
            );
        }
    }
}
