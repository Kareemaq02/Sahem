using Application.Core;
using MediatR;

namespace Application.Commands
{
    public record IncrementComplaintReminderCommand(int Id, string username)
        : IRequest<Result<Unit>>;
}
