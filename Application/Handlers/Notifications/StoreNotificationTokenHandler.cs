using Application.Core;
using Application;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Domain.DataModels.Notifications;
using Microsoft.EntityFrameworkCore;

public class StoreNotificationTokenHandler : IRequestHandler<StoreNotificationTokenCommand, Result<NotificationToken>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;

    public StoreNotificationTokenHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _userManager = userManager;
    }

    public async Task<Result<NotificationToken>> Handle(
        StoreNotificationTokenCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
           .Where(u => u.UserName == request.strUsername)
           .Select(u => u.Id)
           .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var existingToken = await _context.NotificationTokens
        .Where(t => t.intUserId == userId)
        .SingleOrDefaultAsync(cancellationToken);

        var notificationToken = new NotificationToken {
            intUserId = userId,
            strToken = request.strNotificationToken
        };

        if (existingToken == null)
        {
            await _context.NotificationTokens.AddAsync(notificationToken);
        }
        else
        {
            if (existingToken.strToken != notificationToken.strToken)
            {
                _context.NotificationTokens.Attach(existingToken);
                existingToken.strToken = notificationToken.strToken;
            }
            notificationToken = existingToken;
        }
        await _context.SaveChangesAsync(cancellationToken);

        return Result<NotificationToken>.Success(notificationToken);
    }
}
