using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application
{
    public record SubmitTaskCommand(SubmitTaskDTO SubmitTaskDTO, int id)
        : IRequest<Result<SubmitTaskDTO>>;
}
