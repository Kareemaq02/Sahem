using Application.Core;
using MediatR;

namespace Application
{
    public record UnverifyUserByIdCommand(int Id)
        : IRequest<Result<Unit>>;
}