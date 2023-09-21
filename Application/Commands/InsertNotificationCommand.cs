using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;

namespace Application.Commands
{
    public record InsertNotificationCommand(Notification Notification)
        : IRequest<Result<Notification>>;
}
