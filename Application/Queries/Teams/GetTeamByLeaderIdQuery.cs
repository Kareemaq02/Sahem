using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamByLeaderIdQuery(int intLeaderId)
        : IRequest<Result<TeamDTO>>;
}
