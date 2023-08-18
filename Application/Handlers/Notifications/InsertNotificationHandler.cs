using Application.Commands;
using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Notifications
{
    internal class InsertNotificationHandler
        : IRequestHandler<InsertNotificationCommand, Result<Notification>>
    {
        private readonly DataContext _context;

        public InsertNotificationHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<Notification>> Handle(
            InsertNotificationCommand request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUsername)
                .Select(u => u.Id)
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            var notificationEntity = await _context.Notifications.AddAsync(
                new Notification { intTypeId = request.intTypeId, intUserId = userId },
                cancellationToken
            );

            var notification = notificationEntity.Entity;

            await _context.SaveChangesAsync(cancellationToken);

            return Result<Notification>.Success(notification);
        }
    }
}
