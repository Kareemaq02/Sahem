using Application.Core;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetWorkersListQuery(PagingParams PagingParams)
        : IRequest<Result<PagedList<WorkerDTO>>>;
}
