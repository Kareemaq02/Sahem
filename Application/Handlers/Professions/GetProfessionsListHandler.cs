using Application.Core;
using Application.Queries.Professions;
using Domain.ClientDTOs.Department;
using Domain.ClientDTOs.Profession;
using Domain.ClientDTOs.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Departments
{
    public class GetProfessionsListHandler
        : IRequestHandler<GetProfessionsListQuery, Result<List<ProfessionListDTO>>>
    {
        private readonly DataContext _context;

        public GetProfessionsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<ProfessionListDTO>>> Handle(
            GetProfessionsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query = from p in _context.Professions
                        join pu in _context.ProfessionUsers on p.intId equals pu.intProfessionId into professionUsers
                        from professionUser in professionUsers.DefaultIfEmpty()
                        join u in _context.Users on professionUser.intUserId equals u.Id into users
                        from user in users.DefaultIfEmpty()
                        join ui in _context.UserInfos on user.intUserInfoId equals ui.intId into usersInfo
                        from userInfo in usersInfo.DefaultIfEmpty()
                        select new
                        {
                            profession = p,
                            professionUser = professionUser,
                            User = user,
                            UserInfo = userInfo
                        };

            var result = await query
                        .GroupBy(q => new { q.profession.intId, q.profession.strNameAr, q.profession.strNameEn })
                        .OrderBy(g => g.Key.intId)
                        .Select(g => new ProfessionListDTO
                        {
                            intId = g.Key.intId,
                            strNameAr = g.Key.strNameAr,
                            strNameEn = g.Key.strNameEn,
                            lstProfessionWorkers = g.Select(q => new WorkerDTO
                            {
                                intId = q.User != null ? q.User.Id : 0,
                                strFirstName = q.UserInfo != null ? q.UserInfo.strFirstName : null,
                                strLastName = q.UserInfo != null ? q.UserInfo.strLastName : null,
                                strFirstNameAr = q.UserInfo != null ? q.UserInfo.strFirstNameAr : null,
                                strLastNameAr = q.UserInfo != null ? q.UserInfo.strLastNameAr : null,
                                strPhoneNumber = q.UserInfo != null ? q.UserInfo.strPhoneNumber : null,
                            }).Where(worker => worker.intId != 0 || worker.strFirstName != null
                            || worker.strLastName != null || worker.strFirstNameAr != null ||
                            worker.strLastNameAr != null || worker.strPhoneNumber != null)
                            .ToList()
                        })
                        .ToListAsync();


            return Result<List<ProfessionListDTO>>.Success(result);
        }
    }
}
