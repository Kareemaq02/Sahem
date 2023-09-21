using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.Team;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetLoggedInAdminTeamsHandler
        : IRequestHandler<GetLoggedInAdminTeamsQuery, Result<List<TeamListDTO>>>
    {
        private readonly DataContext _context;

        public GetLoggedInAdminTeamsHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<TeamListDTO>>> Handle(
            GetLoggedInAdminTeamsQuery request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(q => q.UserName == request.strUsername)
                .Select(u => u.Id).SingleOrDefaultAsync();

            var query = from team in _context.Teams
                        join d in _context.Departments on team.intDepartmentId equals d.intId
                        where team.intAdminId == userId
                        select
                               new TeamListDTO
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

            return Result<List<TeamListDTO>>.Success(result);
        }
    }
}
