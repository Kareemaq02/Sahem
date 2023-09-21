using Application.Core;
using Application.Queries.Teams;
using Domain.ClientDTOs.Team;
using Domain.ClientDTOs.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetTeamByIdHandler
        : IRequestHandler<GetTeamByIdQuery, Result<TeamDTO>>
    {
        private readonly DataContext _context;

        public GetTeamByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<TeamDTO>> Handle(
            GetTeamByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var query = from team in _context.Teams
                        join d in _context.Departments on team.intDepartmentId equals d.intId
                        where team.intId == request.intTeamId
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
                                   lstWorkers = team.Workers
                                .Select(
                                    ca =>
                                        new TaskWorkerDTO
                                        {
                                            intId = ca.intWorkerId,
                                            strFirstName = ca.Worker.UserInfo.strFirstName,
                                            strLastName = ca.Worker.UserInfo.strLastName,
                                            strFirstNameAr = ca.Worker.UserInfo.strFirstNameAr,
                                            strLastNameAr = ca.Worker.UserInfo.strLastNameAr,
                                            isLeader = team.intLeaderId == ca.intWorkerId
                                        }
                                )
                                .ToList(),

                               };
            var result = await query.FirstOrDefaultAsync();

            return Result<TeamDTO>.Success(result);
        }
    }
}
