using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Tasks
{
    public record GetTasksListQuery(TasksFilter filter) : IRequest<Result<PagedList<TaskListDTO>>>;
}
