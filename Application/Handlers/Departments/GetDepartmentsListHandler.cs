using Application.Core;
using Application.Queries.Departments;
using Domain.ClientDTOs.Department;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;
using Domain.ClientDTOs.User;

namespace Application.Handlers.Departments
{
    public class GetDepartmentsListHandler
        : IRequestHandler<GetDepartmentsListQuery, Result<List<DepartmentListDTO>>>
    {
        private readonly DataContext _context;

        public GetDepartmentsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<DepartmentListDTO>>> Handle(
            GetDepartmentsListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query = from d in _context.Departments
                        join du in _context.DepartmentUsers on d.intId equals du.intDepartmentId into departmentUsers
                        from departmentUser in departmentUsers.DefaultIfEmpty()
                        join u in _context.Users on departmentUser.intUserId equals u.Id into users
                        from user in users.DefaultIfEmpty()
                        join ui in _context.UserInfos on user.intUserInfoId equals ui.intId into usersInfo
                        from userInfo in usersInfo.DefaultIfEmpty()
                        where d.blnIsDeleted == false
                        select new
                        {
                            Department = d,
                            DepartmentUser = departmentUser,
                            User = user,
                            UserInfo = userInfo
                        };

            var result = await query
                        .GroupBy(q => new { q.Department.intId, q.Department.strNameAr, q.Department.strNameEn })
                        .OrderBy(g => g.Key.intId)
                        .Select(g => new DepartmentListDTO
                        {
                            intId = g.Key.intId,
                            strNameAr = g.Key.strNameAr,
                            strNameEn = g.Key.strNameEn,
                            lstDepartmentWorkers = g.Select(q => new WorkerDTO
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
                    


            return Result<List<DepartmentListDTO>>.Success(result);
        }
    }
}
