using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Tasks
{
    public record GetTasksByWorkerIdQuery(int id)
        : IRequest<Result<List<WorkerTaskDTO>>>;
}
