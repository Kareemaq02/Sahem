using Application.Core;
using Application.Queries.Teams;
using Domain.ClientDTOs.Team;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetLoggedInTeamAnalyticsHandler
        : IRequestHandler<GetLoggedInTeamAnaylticsQuery, Result<TeamAnalyticsDTO>>
    {
        private readonly DataContext _context;
        private readonly IMediator _mediator;

        public GetLoggedInTeamAnalyticsHandler(DataContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<Result<TeamAnalyticsDTO>> Handle(
            GetLoggedInTeamAnaylticsQuery request,
            CancellationToken cancellationToken
        )
        {
            var teamMemberId = await _context.Users
                .Where(q => q.UserName == request.strUsername)
                .Select(q => q.Id)
                .SingleOrDefaultAsync();

            var teamId = await _context.TeamMembers
                .Where(q => q.intWorkerId == teamMemberId)
                .Select(q => q.intTeamId)
                .SingleOrDefaultAsync();

            var query = new GetTeamAnalyticsByIdQuery(
                request.filter,
                teamId
            );

            var result = await _mediator.Send(query);

            return Result<TeamAnalyticsDTO>.Success(result.Value);
        }
    }
}
