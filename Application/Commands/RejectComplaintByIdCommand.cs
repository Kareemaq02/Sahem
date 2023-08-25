using Application.Core;
using MediatR;

namespace Application.Commands
{
    public record RejectComplaintByIdCommand(int Id, string username)
        : IRequest<Result<string>>;
}
