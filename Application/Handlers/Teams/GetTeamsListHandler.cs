using Application.Core;
using Application.Queries.Teams;
using Domain.ClientDTOs.Team;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetTeamsListHandler
        : IRequestHandler<GetTeamsListQuery, Result<List<TeamDTO>>>
    {
        private readonly DataContext _context;

        public GetTeamsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<TeamDTO>>> Handle(
            GetTeamsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query = from team in _context.Teams
                        join d in _context.Departments on team.intDepartmentId equals d.intId
                        select
                               new TeamDTO
                               {
                                   intTeamId = team.intId,
                                   intDepartmentId = d.intId,
                                   intTeamLeaderId = team.intLeaderId,
                                   strDepartmentNameAr = d.strNameAr,
                                   strDepartmentNameEn = d.strNameEn,
                                   strTeamLeaderFirstNameAr = team.Leader.UserInfo.strFirstNameAr,
                                   strTeamLeaderFirstNameEn = team.Leader.UserInfo.strFirstName,
                                   strTeamLeaderLastNameAr = team.Leader.UserInfo.strLastNameAr,
                                   strTeamLeaderLastNameEn = team.Leader.UserInfo.strLastName,

                               };
               var result = await query.ToListAsync();

            return Result<List<TeamDTO>>.Success(result);
        }
    }
}
