using Application.Core;
using MediatR;

namespace Application.Commands
{
    public record RemoveProfessionByIdCommand(int intProfessionId, string username)
        : IRequest<Result<string>>;
}
