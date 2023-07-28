using Application.Core;
using MediatR;

namespace Application
{
    public record BlacklistUserByIdCommand(int Id) : IRequest<Result<Unit>>;
}
