using Application.Core;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetCitizensListQuery(UsersFilter filter)
        : IRequest<Result<PagedList<CitizenDTO>>>;
}
