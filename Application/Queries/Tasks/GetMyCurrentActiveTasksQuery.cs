using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetMyCurrentActiveTasksQuery(string strUsername) : IRequest<Result<ActiveTaskDTO>>;
}
