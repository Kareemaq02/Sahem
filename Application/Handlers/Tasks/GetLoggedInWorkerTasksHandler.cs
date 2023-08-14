using Application.Core;
using Application.Queries.Complaints;
using Application.Queries.Tasks;
using Domain.ClientDTOs.Task;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Tasks
{
    public class GetLoggedInWorkerTasksHandler
        : IRequestHandler<GetLoggedInWorkerTasksQuery, Result<List<WorkerTaskDTO>>>
    {
        private readonly DataContext _context;
        private readonly IMediator _mediator;

        public GetLoggedInWorkerTasksHandler(DataContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<Result<List<WorkerTaskDTO>>> Handle(
            GetLoggedInWorkerTasksQuery request,
            CancellationToken cancellationToken
        )
        {
            var workerId = await _context.Users
                .Where(u => u.UserName == request.username)
                .Select(u => u.Id)
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            var tasksByWorkerIdQuery = new GetTasksByWorkerIdQuery(workerId);
            var tasksByWorkerIdResult = await _mediator.Send(tasksByWorkerIdQuery);

            if (tasksByWorkerIdResult.IsSuccess)
            {
                var workerTasks = tasksByWorkerIdResult.Value;
                return Result<List<WorkerTaskDTO>>.Success(workerTasks);
            }
            else
            {
                return Result<List<WorkerTaskDTO>>.Failure("Invalid worker Id");
            }
        }
    }
}