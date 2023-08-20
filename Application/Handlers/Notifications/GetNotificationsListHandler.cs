using Application.Commands;
using Application.Core;
using Application.Queries.Notifications;
using Domain.DataModels.Notifications;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Notifications
{
    public class GetNotificationsListHandler
        : IRequestHandler<GetNotificationsListQuery, Result<List<Notification>>>
    {
        private readonly DataContext _context;

        public GetNotificationsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<Notification>>> Handle(
            GetNotificationsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUsername)
                .Select(u => u.Id)
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            var result = await _context.Notifications
                .Where(n => n.intUserId == userId)
                .ToListAsync(cancellationToken: cancellationToken);

            return Result<List<Notification>>.Success(result);
        }
    }
}
