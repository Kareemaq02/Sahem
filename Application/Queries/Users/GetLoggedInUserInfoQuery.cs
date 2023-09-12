using Application.Core;
using Domain.ClientDTOs.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetLoggedInUserInfoQuery(string strUsername) : IRequest<Result<DetailedUserDTO>>;
}
