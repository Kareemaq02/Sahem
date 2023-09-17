using Application.Commands;
using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Notifications
{
    public class InsertNotificationHandler
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
            var notificationEntity = await _context.Notifications.AddAsync(request.Notification);

            var notification = notificationEntity.Entity;

            await _context.SaveChangesAsync(cancellationToken);

            return Result<Notification>.Success(notification);
        }
    }
}
