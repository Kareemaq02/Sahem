using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Watchers_Table : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "complaints_watchers",
                columns: table => new
                {
                    USER_ID = table.Column<int>(type: "int", nullable: false),
                    COMPLAINT_ID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_complaints_watchers", x => new { x.USER_ID, x.COMPLAINT_ID });
                    table.ForeignKey(
                        name: "FK_complaints_watchers_complaints_COMPLAINT_ID",
                        column: x => x.COMPLAINT_ID,
                        principalTable: "complaints",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_complaints_watchers_users_USER_ID",
                        column: x => x.USER_ID,
                        principalTable: "users",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_complaints_watchers_COMPLAINT_ID",
                table: "complaints_watchers",
                column: "COMPLAINT_ID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "complaints_watchers");
        }
    }
}
