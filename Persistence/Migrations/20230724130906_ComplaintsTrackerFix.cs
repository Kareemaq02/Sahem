using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ComplaintsTrackerFix : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_complaints_statuses_complaints_STATUS_ID",
                table: "complaints_statuses");

            migrationBuilder.DropForeignKey(
                name: "FK_complaints_statuses_complaints_status_COMPLAINT_ID",
                table: "complaints_statuses");

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_statuses_complaints_COMPLAINT_ID",
                table: "complaints_statuses",
                column: "COMPLAINT_ID",
                principalTable: "complaints",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_statuses_complaints_status_STATUS_ID",
                table: "complaints_statuses",
                column: "STATUS_ID",
                principalTable: "complaints_status",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_complaints_statuses_complaints_COMPLAINT_ID",
                table: "complaints_statuses");

            migrationBuilder.DropForeignKey(
                name: "FK_complaints_statuses_complaints_status_STATUS_ID",
                table: "complaints_statuses");

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_statuses_complaints_STATUS_ID",
                table: "complaints_statuses",
                column: "STATUS_ID",
                principalTable: "complaints",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_complaints_statuses_complaints_status_COMPLAINT_ID",
                table: "complaints_statuses",
                column: "COMPLAINT_ID",
                principalTable: "complaints_status",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
