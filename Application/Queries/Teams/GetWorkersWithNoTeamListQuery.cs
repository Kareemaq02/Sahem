using Application.Core;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetWorkersWithNoTeamListQuery(PagingParams PagingParams)
        : IRequest<Result<PagedList<WorkerDTO>>>;
}
