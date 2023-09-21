using Application.Core;
using Domain.ClientDTOs.Department;
using Domain.DataModels.LookUps;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.DataModels.Intersections;
using Application.Commands;
using Application.Services;
using Domain.Helpers;
using Domain.Resources;
using Domain.DataModels.Notifications;

namespace Application.Handlers.LookUps
{
    public class InsertWorkerToDepartmentHandler
        : IRequestHandler<AddWorkerToDepartmentCommand, Result<string>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public InsertWorkerToDepartmentHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<string>> Handle(
            AddWorkerToDepartmentCommand request,
            CancellationToken cancellationToken
        )
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            if (
                _context.DepartmentUsers.Any(
                    d =>
                        d.intUserId == request.intWorkerId
                        && d.intDepartmentId == request.intDepartmentId
                )
            )
                return Result<string>.Failure("Worker is already in specified department");



            var departmentUser = new DepartmentUsers
            {
                intUserId = request.intWorkerId,
                intDepartmentId = request.intDepartmentId
            };

            await _context.DepartmentUsers.AddAsync(departmentUser, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
            //Insert into Notifications Table
            try
            {
                var username = await _context.Users.
                    Where(q => q.Id == request.intWorkerId).Select(c => c.UserName).SingleOrDefaultAsync();

                var notificationLayout = await _context.NotificationTypes
                    .Where(q => q.intId == (int)NotificationConstant.NotificationType.workerAddedToDepartmentNotification)
                    .Select(q => new NotificationLayout
                    {
                        strHeaderAr = q.strHeaderAr,
                        strBodyAr = q.strBodyAr,
                        strBodyEn = q.strBodyEn,
                        strHeaderEn = q.strHeaderEn
                    }).SingleOrDefaultAsync();

                var notificationToken = await _context.NotificationTokens
                .Where(q => q.intUserId == request.intWorkerId)
                .Select(q => q.strToken).FirstOrDefaultAsync();

                if (notificationLayout == null)
                    throw new Exception("Notification Type table is empty");

                //Get Department name in arabic and in english
                var departmentNames = await _context.Departments
                    .Where(q => q.intId == request.intDepartmentId)
                    .Select(q => new Department { strNameAr = q.strNameAr, strNameEn = q.strNameEn }).SingleOrDefaultAsync();


                string headerAr = notificationLayout.strHeaderAr + departmentNames.strNameAr;
                string bodyAr = "قسم ال" + departmentNames.strNameAr + " " + notificationLayout.strBodyAr;
                string headerEn = notificationLayout.strHeaderEn + " " + departmentNames.strNameEn + " department.";
                string strBodyEn = "Department " + departmentNames.strNameEn + " " + notificationLayout.strBodyEn;

                await _mediator.
                    Send(new InsertNotificationCommand(new Notification
                    {
                        intTypeId = (int)NotificationConstant.NotificationType.workerAddedToDepartmentNotification,
                        intUserId = request.intWorkerId,
                        strHeaderAr = headerAr,
                        strBodyAr = bodyAr,
                        strHeaderEn = headerEn,
                        strBodyEn = strBodyEn,
                    }));

                string notificationJson = $"{{" +
            $"\"to\": \"{notificationToken}\"," +
            $"\"notification\": {{" +
            $"\"title\": \"{headerAr}\"," +
            $"\"body\": \"{bodyAr}\"" +
            $"}}" +
            $"}}";

                // Get Notification body and header

                await _notificationService
                    .SendNotificationAsync(notificationJson);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString()); 
            }

           
            await transaction.CommitAsync(cancellationToken);
            return Result<string>.Success("Worker added successfully");
        }
    }
}
