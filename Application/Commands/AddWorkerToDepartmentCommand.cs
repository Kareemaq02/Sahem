using Application.Core;
using MediatR;

namespace Application
{
    public record AddWorkerToDepartmentCommand(int intWorkerId, int intDepartmentId) : IRequest<Result<String>>;
}
