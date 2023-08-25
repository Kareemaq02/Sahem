using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.Resources;
using System.Threading;
using System.Threading.Tasks; // Add this using statement

namespace Application.Handlers.Users
{
    public class GetAvailableWorkersListHandler
        : IRequestHandler<GetAvailableWorkersListQuery, Result<List<WorkerDTO>>>
    {
        private readonly DataContext _context;

        public GetAvailableWorkersListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<WorkerDTO>>> Handle(
            GetAvailableWorkersListQuery request,
            CancellationToken cancellationToken
        )
        {
            DateTime date = request.startDate;
            DateTime date2 = request.endDate;
            var busyWorkerIdsQuery =
                from u in _context.Users
                join tm in _context.TeamMembers on u.Id equals tm.intWorkerId
                join t in _context.Tasks on tm.intTeamId equals t.intId
                where
                    u.intUserTypeId == (int)UsersConstant.userTypes.worker
                    && (t.dtmDateScheduled <= date && t.dtmDateDeadline >= date2)
                select u.Id;

            //Query to get available workers
            var availableWorkersQuery =
                from u in _context.Users
                join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                where
                    u.intUserTypeId == (int)UsersConstant.userTypes.worker
                    && !busyWorkerIdsQuery.Contains(u.Id)
                group u by new
                {
                    u.Id,
                    ui.strFirstName,
                    ui.strLastName,
                    ui.strPhoneNumber
                } into g
                select new WorkerDTO
                {
                    intId = g.Key.Id,
                    strFirstName = g.Key.strFirstName,
                    strLastName = g.Key.strLastName,
                    strPhoneNumber = g.Key.strPhoneNumber
                };

            var result = await availableWorkersQuery.ToListAsync();

            return Result<List<WorkerDTO>>.Success(result);
        }
    }
}
