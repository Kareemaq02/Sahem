using Application.Core;
using MediatR;

namespace Application
{
    public record WhitelistUserByIdCommand(int Id)
        : IRequest<Result<Unit>>;
}