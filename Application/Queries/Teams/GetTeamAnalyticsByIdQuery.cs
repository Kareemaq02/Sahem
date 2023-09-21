using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamAnalyticsByIdQuery(int intTeamId)
        : IRequest<Result<TeamAnalyticsDTO>>;
}
