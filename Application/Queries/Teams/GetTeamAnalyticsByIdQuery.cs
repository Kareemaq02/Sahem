using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamAnalyticsByIdQuery(FromTo_DateFilter filter
        ,int intTeamId)
        : IRequest<Result<TeamAnalyticsDTO>>;
}
