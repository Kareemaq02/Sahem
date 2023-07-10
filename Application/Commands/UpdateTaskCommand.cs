using Application.Core;
using Application.Handlers.Tasks;
using MediatR;

namespace Application.Commands
{
    public record UpdateTaskCommand(UpdateTaskDTO updateTaskDTO, int Id)
        : IRequest<Result<UpdateTaskDTO>>;
}