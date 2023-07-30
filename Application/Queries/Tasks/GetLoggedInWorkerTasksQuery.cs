using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetLoggedInWorkerTasksQuery(string username)
        : IRequest<Result<List<WorkerTaskDTO>>>;
}
