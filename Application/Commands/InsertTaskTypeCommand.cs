using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application
{
    public record InsertTaskTypeCommand(TaskTypeDTO TaskTypeDTO) : IRequest<Result<TaskTypeDTO>>;
}
