using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;

namespace Application.Commands
{
    public record InsertNotificationCommand(string strUsername, int intTypeId)
        : IRequest<Result<Notification>>;
}
