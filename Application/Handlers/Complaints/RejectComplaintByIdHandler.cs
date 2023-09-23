using Application.Core;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Application.Services;
using Domain.Helpers;
using Domain.DataModels.Notifications;

public class RejectComplaintByIdHandler
    : IRequestHandler<RejectComplaintByIdCommand, Result<string>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;
    private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;
    private readonly NotificationService _notificationService;
    private readonly IMediator _mediator;

    public RejectComplaintByIdHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager,
        AddComplaintStatusChangeTransactionHandler transactionHandler,
        NotificationService notificationService,
        IMediator mediator
    )
    {
        _context = context;
        _userManager = userManager;
        _transactionHandler = transactionHandler;
        _notificationService = notificationService;
        _mediator = mediator;
    }

    public async Task<Result<string>> Handle(
        RejectComplaintByIdCommand request,
        CancellationToken cancellationToken
    )
    {
        var adminId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        // transaction start...

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var complaintStatus = await _context.Complaints
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (complaintStatus == (int)ComplaintsConstant.complaintStatus.pending)
            {
                Complaint complaint = new Complaint { intId = request.Id };
                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.rejected;
                complaint.dtmDateLastModified = DateTime.UtcNow;
                complaint.intLastModifiedBy = adminId;

                await _context.SaveChangesAsync(cancellationToken);

                await _transactionHandler.Handle(
                    new AddComplaintStatusChangeTransactionCommand(
                        request.Id,
                        (int)ComplaintsConstant.complaintStatus.rejected
                    ),
                    cancellationToken
                );
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<string>.Failure("Only pending complaints can be rejected.");
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync();
            return Result<string>.Failure("Failed to update complaint.");
        }

        try
        {
            //Insert into Notifications Table

            var rejectedComplaintUserId = await _context.Complaints
                .Where(q => q.intId == request.Id)
                .Select(c => c.intUserID)
                .SingleOrDefaultAsync();

            var username = await _context.Users
                .Where(q => q.Id == rejectedComplaintUserId)
                .Select(c => c.UserName)
                .SingleOrDefaultAsync();

            var notificationToken = await _context.NotificationTokens
                .Where(q => q.intUserId == rejectedComplaintUserId)
                .Select(q => q.strToken).FirstOrDefaultAsync();

            // Get Notification body and header
            var notificationLayout = await _context.NotificationTypes
                .Where(
                    q =>
                        q.intId
                        == (int)NotificationConstant.NotificationType.rejectedComplaintNotification
                )
                .Select(
                    q =>
                        new NotificationLayout
                        {
                            strHeaderAr = q.strHeaderAr,
                            strBodyAr = q.strBodyAr,
                            strBodyEn = q.strBodyEn,
                            strHeaderEn = q.strHeaderEn
                        }
                )
                .SingleOrDefaultAsync();

            if (notificationLayout == null)
                throw new Exception("Notification Type table is empty");

            string headerAr = notificationLayout.strHeaderAr;
            string bodyAr = notificationLayout.strBodyAr + " " + request.Id;

            string headerEn = notificationLayout.strHeaderEn;
            string strBodyEn = notificationLayout.strBodyEn + " " + request.Id + " has been rejected.";


            string notificationJson = $"{{" +
             $"\"to\": \"{notificationToken}\"," +
             $"\"notification\": {{" +
             $"\"title\": \"{headerAr}\"," +
             $"\"body\": \"{bodyAr}\"" +
             $"}}" +
             $"}}";

            await _mediator.
                Send(new InsertNotificationCommand(new Notification
                {
                    intTypeId = (int)NotificationConstant.NotificationType.rejectedComplaintNotification,
                    intUserId = rejectedComplaintUserId,

                    strHeaderAr = headerAr,
                    strBodyAr = bodyAr,

                    strHeaderEn = headerEn,
                    strBodyEn = strBodyEn,
                }));


            await _notificationService.SendNotificationAsync(notificationJson);
        }
        catch (Exception e)
        {
            Console.WriteLine(e.ToString());
        }

        await transaction.CommitAsync();
        return Result<string>.Success("Complaint rejected.");
    }
}
