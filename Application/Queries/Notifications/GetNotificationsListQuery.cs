using Application.Core;
using Domain.DataModels.Notifications;
using MediatR;

namespace Application.Queries.Notifications
{
    public record GetNotificationsListQuery(string strUsername)
        : IRequest<Result<List<Notification>>>;
}
