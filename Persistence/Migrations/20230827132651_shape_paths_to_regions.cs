using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class shape_paths_to_regions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_complaints_regions_REGION",
                table: "complaints"
            );

            // FAULTY GENERATED SQL
            // migrationBuilder.RenameColumn(
            //    name: "REGION",
            //    table: "complaints",
            //    newName: "REGION_ID"
            //);

            // MANUAL SQL
            migrationBuilder.Sql("ALTER TABLE complaints RENAME COLUMN REGION TO REGION_ID;");

            migrationBuilder.RenameIndex(
                name: "IX_complaints_REGION",
                table: "complaints",
                newName: "IX_complaints_REGION_ID"
            );

            migrationBuilder.AddColumn<string>(
                name: "SHAPE_PATH",
                table: "regions",
                type: "longtext",
                nullable: false
            );

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_regions_REGION_ID",
                table: "complaints",
                column: "REGION_ID",
                principalTable: "regions",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_complaints_regions_REGION_ID",
                table: "complaints"
            );

            migrationBuilder.DropColumn(name: "SHAPE_PATH", table: "regions");

            migrationBuilder.RenameColumn(
                name: "REGION_ID",
                table: "complaints",
                newName: "REGION"
            );

            migrationBuilder.RenameIndex(
                name: "IX_complaints_REGION_ID",
                table: "complaints",
                newName: "IX_complaints_REGION"
            );

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_regions_REGION",
                table: "complaints",
                column: "REGION",
                principalTable: "regions",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade
            );
        }
    }
}
