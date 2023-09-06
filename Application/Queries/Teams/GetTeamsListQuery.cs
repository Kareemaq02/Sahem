using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamsListQuery()
        : IRequest<Result<List<TeamDTO>>>;
}
