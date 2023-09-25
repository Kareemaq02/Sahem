using Application.Core;
using Application.Queries.Teams;
using Domain.ClientDTOs.Team;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetTeamAnalyticsByIdHandler
        : IRequestHandler<GetTeamAnalyticsByIdQuery, Result<TeamAnalyticsDTO>>
    {
        private readonly DataContext _context;

        public GetTeamAnalyticsByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<TeamAnalyticsDTO>> Handle(
            GetTeamAnalyticsByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var query =
                from tasks in _context.Tasks
                where tasks.intTeamId == request.intTeamId
                select new
                {
                    intTaskId = tasks.intId,
                    intTaskStatusId = tasks.intStatusId,
                    dtmDateScheduled = tasks.dtmDateScheduled,
                    dtmDateDeadline = tasks.dtmDateDeadline
                };

            if (
                request.filter.dtmDatefrom > DateTime.MinValue
                && request.filter.dtmDateTo == DateTime.MinValue
            )
            {
                query = query.Where(c => c.dtmDateScheduled >= request.filter.dtmDatefrom);
            }

            if (
                request.filter.dtmDateTo > DateTime.MinValue
                && request.filter.dtmDatefrom == DateTime.MinValue
            )
            {
                query = query.Where(c => c.dtmDateDeadline <= request.filter.dtmDateTo);
            }

            if (
                request.filter.dtmDatefrom > DateTime.MinValue
                && request.filter.dtmDateTo > DateTime.MinValue
            )
            {
                query = query.Where(
                    c =>
                        c.dtmDateDeadline <= request.filter.dtmDateTo
                        && c.dtmDateScheduled >= request.filter.dtmDatefrom
                );
            }

            var AnalyticsDTO = new TeamAnalyticsDTO
            {
                intTasksCompletedCount = await query
                    .Where(q => q.intTaskStatusId == (int)TasksConstant.taskStatus.completed)
                    .CountAsync(),
                intTasksIncompleteCount = await query
                    .Where(q => q.intTaskStatusId == (int)TasksConstant.taskStatus.incomplete)
                    .CountAsync(),
                intTasksScheduledCount = await query
                    .Where(q => q.intTaskStatusId == (int)TasksConstant.taskStatus.inactive)
                    .CountAsync(),
                intTasksCount = await query.CountAsync(),
                intTeamId = request.intTeamId,
            };

            var intTeamLeaderId = await _context.Teams
                .Where(q => q.intId == request.intTeamId)
                .Select(q => q.intLeaderId)
                .SingleOrDefaultAsync();

            var queryTeam =
                from teamMembers in _context.TeamMembers
                where
                    teamMembers.intTeamId == request.intTeamId
                select new TeamMemberRatingDTO
                {
                    intWorkerId = teamMembers.intWorkerId,
                    strMemberFirstNameAr = teamMembers.Worker.UserInfo.strFirstNameAr,
                    strMemberLastNameAr = teamMembers.Worker.UserInfo.strLastNameAr,
                    strMemberFirstNameEn = teamMembers.Worker.UserInfo.strFirstName,
                    strMemberLastNameEn = teamMembers.Worker.UserInfo.strLastName
                };
            var team = await queryTeam.ToListAsync();

            foreach (var teamMember in team)
            {
                  if (teamMember.intWorkerId == intTeamLeaderId)
                    continue;

                var rating = await _context.TasksMembersRatings
                    .Where(q => q.intUserId == teamMember.intWorkerId)
                    .Select(q => q.decRating)
                    .ToListAsync();

                decimal rate = 0;

                foreach (var member in rating)
                {
                    rate += member;
                    Console.WriteLine(rate);
                }
                if (rating.Count() != 0)
                    teamMember.decMemberRating = rate / rating.Count();

                AnalyticsDTO.decTeamRatingAvg += teamMember.decMemberRating;
            }

            AnalyticsDTO.decTeamRatingAvg = AnalyticsDTO.decTeamRatingAvg / team.Count();
            AnalyticsDTO.lstMembersAvgRating = team;
            return Result<TeamAnalyticsDTO>.Success(AnalyticsDTO);
        }
    }
}
