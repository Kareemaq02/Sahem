using Application.Core;
using MediatR;

namespace Application.Commands
{
    public record RemoveDepartmentByIdCommand(int intDepartmentId, string username)
        : IRequest<Result<string>>;
}
