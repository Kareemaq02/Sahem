using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application
{
    public record InsertTaskCommand(TaskDTO TaskDTO) : IRequest<Result<TaskDTO>>;
}
