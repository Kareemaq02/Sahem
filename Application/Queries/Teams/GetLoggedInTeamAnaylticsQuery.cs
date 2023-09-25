using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetLoggedInTeamAnaylticsQuery(FromTo_DateFilter filter, string strUsername)
        : IRequest<Result<TeamAnalyticsDTO>>;
}
