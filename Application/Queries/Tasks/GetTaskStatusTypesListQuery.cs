using Application.Core;
using Domain.ClientDTOs.SharedDTOs;
using MediatR;

namespace Application.Queries.Tasks
{
    public record GetTaskStatusTypesListQuery() : IRequest<Result<List<StatusDTO>>>;
}
