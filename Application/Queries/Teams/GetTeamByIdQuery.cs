using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamByIdQuery(int intTeamId)
        : IRequest<Result<TeamDTO>>;
}
