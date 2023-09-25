using Application.Core;
using Application.Queries.Users;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.ClientDTOs.Team;
using Domain.Helpers;
using Application.Queries.Teams;
using Domain.Resources;
using MySqlX.XDevAPI.Common;

namespace Application.Handlers.Teams
{
    public class GetTeamBusyDatesHandler
        : IRequestHandler<GetTeamBusyDatesQuery, Result<List<DateRange>>>
    {
        private readonly DataContext _context;

        public GetTeamBusyDatesHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<DateRange>>> Handle(
            GetTeamBusyDatesQuery request,
            CancellationToken cancellationToken
        )
        {
            var result = await _context.Tasks
                .Where(
                    t =>
                        (
                            t.intStatusId == (int)TasksConstant.taskStatus.inProgress
                            || t.intStatusId == (int)TasksConstant.taskStatus.inactive
                        )
                        && t.intTeamId == request.intTeamId
                )
                .Select(
                    q =>
                        new DateRange
                        {
                            dtmStartDate = q.dtmDateScheduled,
                            dtmEndDate = q.dtmDateDeadline
                        }
                )
                .ToListAsync();

            return Result<List<DateRange>>.Success(result);
        }
    }
}
