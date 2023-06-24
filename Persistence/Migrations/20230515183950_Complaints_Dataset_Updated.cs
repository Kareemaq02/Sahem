using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Complaints_Dataset_Updated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // FAULTY GENERATED SQL
            //migrationBuilder.DropColumn(
            //    name: "IS_HOST",
            //    table: "complaints_voters");

            // MANUAL SQL
            migrationBuilder.Sql("ALTER TABLE complaints_voters DROP COLUMN IS_HOST;");

            // FAULTY GENERATED SQL
            //migrationBuilder.AddColumn<decimal>(
            //    name: "USER_RATING",
            //    table: "tasks",
            //    type: "decimal(18,2)",
            //    nullable: false,
            //    defaultValue: 0m
            //);

            // MANUAL SQL
            migrationBuilder.Sql(
                "ALTER TABLE tasks ADD COLUMN USER_RATING decimal(18,2) NOT NULL DEFAULT 0.0;"
            );

            // FAULTY GENERATED SQL
            //migrationBuilder.AddColumn<bool>(
            //    name: "IS_REFILED",
            //    table: "complaints",
            //    type: "tinyint(1)",
            //    nullable: false,
            //    defaultValue: false
            //);

            // MANUAL SQL
            migrationBuilder.Sql(
                "ALTER TABLE complaints ADD COLUMN IS_REFILED TINYINT(1) NOT NULL DEFAULT 0;"
            );

            migrationBuilder
                .CreateTable(
                    name: "complaints_statuses",
                    columns: table =>
                        new
                        {
                            COMPLAINT_ID = table.Column<int>(type: "int", nullable: false),
                            STATUS_ID = table.Column<int>(type: "int", nullable: false),
                            TRANS_DATE = table.Column<DateTime>(
                                type: "datetime(6)",
                                nullable: false
                            )
                        },
                    constraints: table =>
                    {
                        table.PrimaryKey(
                            "PK_complaints_statuses",
                            x => new { x.COMPLAINT_ID, x.STATUS_ID }
                        );
                        table.ForeignKey(
                            name: "FK_complaints_statuses_complaints_STATUS_ID",
                            column: x => x.STATUS_ID,
                            principalTable: "complaints",
                            principalColumn: "ID",
                            onDelete: ReferentialAction.Cascade
                        );
                        table.ForeignKey(
                            name: "FK_complaints_statuses_complaints_status_COMPLAINT_ID",
                            column: x => x.COMPLAINT_ID,
                            principalTable: "complaints_status",
                            principalColumn: "ID",
                            onDelete: ReferentialAction.Cascade
                        );
                    }
                )
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_complaints_statuses_STATUS_ID",
                table: "complaints_statuses",
                column: "STATUS_ID"
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "complaints_statuses");

            migrationBuilder.DropColumn(name: "USER_RATING", table: "tasks");

            migrationBuilder.DropColumn(name: "IS_REFILED", table: "complaints");

            migrationBuilder.AddColumn<bool>(
                name: "IS_HOST",
                table: "complaints_voters",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false
            );
        }
    }
}
