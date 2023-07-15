using Application.Core;
using MediatR;

namespace Application
{
    public record VerifyUserByIdCommand(int Id)
        : IRequest<Result<Unit>>;
}