using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Tasks
{
    public record GetTasksListQuery(PagingParams PagingParams)
        : IRequest<Result<PagedList<TaskListDTO>>>;
}
