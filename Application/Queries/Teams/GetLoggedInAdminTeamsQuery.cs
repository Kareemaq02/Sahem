using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Users
{
    public record GetLoggedInAdminTeamsQuery(string strUsername) :
        IRequest<Result<List<TeamListDTO>>>;
}
