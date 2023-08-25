using Application.Core;
using Application.Handlers.Tasks;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Commands
{
    public record AddComplaintToExistingTaskCommand
        (AddComplaintToExistingTaskDTO addComplaintToTaskDTO) :
        IRequest<Result<AddComplaintToExistingTaskDTO>>;
}
