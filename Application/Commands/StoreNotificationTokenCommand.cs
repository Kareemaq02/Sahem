using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;

namespace Application
{
    public record StoreNotificationTokenCommand(string strUsername, string strNotificationToken) : IRequest<Result<NotificationToken>>;
}
