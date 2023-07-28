using Application.Core;
using Application.Handlers.Tasks;
using MediatR;

namespace Application.Commands
{
    public record ActivateTaskCommand(int Id, string username) : IRequest<Result<Unit>>;
}
