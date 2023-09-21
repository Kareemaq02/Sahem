using Application.Core;
using Application.Queries.Users;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.ClientDTOs.Team;

namespace Application.Handlers.Teams
{
    public class CheckIfTeamIsAvailableByIdHandler
        : IRequestHandler<CheckIfTeamIsAvailableByIdQuery, Result<bool>>
    {
        private readonly DataContext _context;

        public CheckIfTeamIsAvailableByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<bool>> Handle(
            CheckIfTeamIsAvailableByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            DateTime startDate = request.startDate;
            DateTime endDate = request.endDate;

            var busyTeamIdsQuery =
                from teams in _context.Teams
                join t in _context.Tasks on teams.intId equals t.intTeamId into joinedTeamTask
                from joinedResult in joinedTeamTask.DefaultIfEmpty()
                where !(
                        joinedResult.dtmDateDeadline > endDate && joinedResult.dtmDateScheduled > endDate
                        || joinedResult.dtmDateDeadline < startDate && joinedResult.dtmDateScheduled < startDate
                    ) && joinedResult.intTeamId == request.intTeamId
                select teams.intId;

            busyTeamIdsQuery = busyTeamIdsQuery.Distinct();


            var vacTeamIdsQuery =
                from teams in _context.Teams
                join w in _context.WorkerVacations on teams.intLeaderId equals w.intWorkerId
                where !(w.dtmEndDate > endDate && w.dtmStartDate > endDate
                        || w.dtmEndDate < startDate && w.dtmStartDate < startDate) && teams.intId == request.intTeamId
                select teams.intId;



            var availableTeamsQuery =
                from t in _context.Teams
                join d in _context.Departments on t.intDepartmentId equals d.intId
                join ui in _context.UserInfos on t.intLeaderId equals ui.intId
                where !busyTeamIdsQuery.Contains(t.intId) && !vacTeamIdsQuery.Contains(t.intId) && t.intId == request.intTeamId
                orderby t.intId
                select new TeamListDTO
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

            var result = await availableTeamsQuery.Distinct().AnyAsync();

            return Result<bool>.Success(result);
        }
    }
}
