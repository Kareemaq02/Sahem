using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

#nullable disable

namespace Persistence.Migrations
{
    /// <inheritdoc />
    public partial class added_notifications : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "messages",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    ADMIN_ID = table.Column<int>(type: "int", nullable: false),
                    USER_ID = table.Column<int>(type: "int", nullable: false),
                    HEADER = table.Column<string>(type: "longtext", nullable: false),
                    BODY = table.Column<string>(type: "longtext", nullable: false),
                    DATE_CREATED = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_messages", x => x.ID);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "notification_types",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    HEADER_AR = table.Column<string>(type: "longtext", nullable: false),
                    HEADER_EN = table.Column<string>(type: "longtext", nullable: false),
                    BODY_AR = table.Column<string>(type: "longtext", nullable: false),
                    BODY_EN = table.Column<string>(type: "longtext", nullable: false),
                    CREATED_BY = table.Column<int>(type: "int", nullable: false),
                    DATE_CREATED = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    LAST_MODIFIED_BY = table.Column<int>(type: "int", nullable: false),
                    DATE_LAST_MODIFIED = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    IS_DELETED = table.Column<bool>(type: "tinyint(1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_notification_types", x => x.ID);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "notifications",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    TYPE_ID = table.Column<int>(type: "int", nullable: false),
                    USER_ID = table.Column<int>(type: "int", nullable: false),
                    DATE_CREATED = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_notifications", x => x.ID);
                    table.ForeignKey(
                        name: "FK_notifications_notification_types_TYPE_ID",
                        column: x => x.TYPE_ID,
                        principalTable: "notification_types",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_notifications_TYPE_ID",
                table: "notifications",
                column: "TYPE_ID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "messages");

            migrationBuilder.DropTable(
                name: "notifications");

            migrationBuilder.DropTable(
                name: "notification_types");
        }
    }
}
