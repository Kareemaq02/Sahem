using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Commands
{
    public record UpdateTaskCommand(UpdateTaskDTO updateTaskDTO, int Id)
        : IRequest<Result<UpdateTaskDTO>>;
}
