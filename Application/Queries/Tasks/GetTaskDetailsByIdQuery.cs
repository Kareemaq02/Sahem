using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetTaskDetailsByIdQuery(int Id) : IRequest<Result<DetailedTaskDTO>>;
}
