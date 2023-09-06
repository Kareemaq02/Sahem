using Application.Core;
using Application.Queries.Users;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.ClientDTOs.Team;

namespace Application.Handlers.Teams
{
    public class GetAvailableTeamsListHandler
        : IRequestHandler<GetAvailableTeamsListQuery, Result<List<TeamDTO>>>
    {
        private readonly DataContext _context;

        public GetAvailableTeamsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<TeamDTO>>> Handle(
            GetAvailableTeamsListQuery request,
            CancellationToken cancellationToken
        )
        {
            DateTime startDate = request.startDate;
            DateTime endDate = request.endDate;
            var busyTeamIdsQuery =
                from teams in _context.Teams
                join t in _context.Tasks on teams.intId equals t.intTeamId
                where !(
                        t.dtmDateDeadline > endDate && t.dtmDateScheduled > endDate
                        || t.dtmDateDeadline < startDate && t.dtmDateScheduled < startDate
                    )
                select teams.intId;


            var availableTeamsQuery =
                from t in _context.Teams
                join d in _context.Departments on t.intDepartmentId equals d.intId
                join ui in _context.UserInfos on t.intLeaderId equals ui.intId
                where !busyTeamIdsQuery.Contains(t.intId)
                orderby t.intId
                select new TeamDTO
                {
                    intTeamId = t.intId,
                    intTeamLeaderId = t.intLeaderId,
                    intDepartmentId = d.intId,
                    strDepartmentNameAr = d.strNameAr,
                    strDepartmentNameEn = d.strNameEn,
                    strTeamLeaderFirstNameEn = ui.strFirstName,
                    strTeamLeaderFirstNameAr = ui.strFirstNameAr,
                    strTeamLeaderLastNameAr = ui.strLastNameAr,
                    strTeamLeaderLastNameEn = ui.strLastName
                };

            var result = await availableTeamsQuery.Distinct().ToListAsync();

            return Result<List<TeamDTO>>.Success(result);
        }
    }
}
