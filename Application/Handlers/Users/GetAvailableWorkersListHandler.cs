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
    public class GetAvailableWorkersListHandler : IRequestHandler<GetAvailableWorkersListQuery, Result<List<WorkerDTO>>>
    {
        private readonly DataContext _context;

        public GetAvailableWorkersListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<WorkerDTO>>> Handle(GetAvailableWorkersListQuery request, CancellationToken cancellationToken)
        {
            DateTime startDate = request.startDate;
            DateTime endDate = request.endDate;
            var busyWorkerIdsQuery = from u in _context.Users
                                     join tm in _context.TaskMembers on u.Id equals tm.intWorkerId
                                     join t in _context.Tasks on tm.intTaskId equals t.intId into tasks
                                     from taskQ in tasks.DefaultIfEmpty()
                                     where u.intUserTypeId == 2 &&
                   !((taskQ.dtmDateDeadline > endDate && taskQ.dtmDateScheduled > endDate) ||
                     (taskQ.dtmDateDeadline < startDate && taskQ.dtmDateScheduled < startDate))
                                     select u.Id;

            Console.WriteLine(startDate);
            Console.WriteLine(endDate);
            //Query to get available workers
            /* var availableWorkersQuery = from u in _context.Users
                                         join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                                         where u.intUserTypeId == (int)UsersConstant.userTypes.worker
                                         && !busyWorkerIdsQuery.Contains(u.Id)
                                         group u by new
                                         {
                                             u,
                                             u.Id,
                                             ui.strFirstName,
                                             ui.strFirstNameAr,
                                             ui.strLastNameAr,
                                             ui.strLastName,
                                             ui.strPhoneNumber
                                         } into g
                                         select new WorkerDTO
                                         {
                                             intId = g.Key.Id,
                                             strFirstName = g.Key.strFirstName,
                                             strLastName = g.Key.strLastName,
                                             strFirstNameAr = g.Key.strFirstNameAr,
                                             strLastNameAr = g.Key.strLastNameAr,
                                             strPhoneNumber = g.Key.strPhoneNumber,
                                             strProfessionAr = g.Key.u.Professions.Select(q => q.Profession.strNameEn).FirstOrDefault()
                                         };*/


            var availableWorkersQuery = from u in _context.Users
                                        join ui in _context.UserInfos on u.intUserInfoId equals ui.intId
                                        where u.intUserTypeId == (int)UsersConstant.userTypes.worker
                                         && !busyWorkerIdsQuery.Contains(u.Id)
                                         orderby u.Id
                                        select new WorkerDTO {
                                            intId = u.Id,
                                            strFirstName = ui.strFirstName,
                                            strLastName = ui.strLastName,
                                            strFirstNameAr = ui.strFirstNameAr,
                                            strLastNameAr = ui.strLastNameAr,
                                            strPhoneNumber = ui.strPhoneNumber,
                                            strProfessionEn = u.Professions.Select(q => q.Profession.strNameEn).FirstOrDefault(),
                                            strProfessionAr = u.Professions.Select(q => q.Profession.strNameAr).FirstOrDefault()
                                        };

            var result = await availableWorkersQuery.Distinct().ToListAsync();

            return Result<List<WorkerDTO>>.Success(result);
        }
    }
}
