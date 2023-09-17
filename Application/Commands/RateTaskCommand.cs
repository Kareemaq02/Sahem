using Application.Core;
using Application.Handlers.Tasks;
using MediatR;

namespace Application.Commands
{
    public record RateTaskCommand(int Id, decimal decRating,string username) : IRequest<Result<Unit>>;
}
