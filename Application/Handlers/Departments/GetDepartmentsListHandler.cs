using Application.Core;
using Application.Queries.Departments;
using Domain.ClientDTOs.Department;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

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
            List<DepartmentListDTO> result = await _context.Departments
                .Select(
                    q =>
                        new DepartmentListDTO
                        {
                            intId = q.intId,
                            strNameAr = q.strNameAr,
                            strNameEn = q.strNameEn,
                        }
                )
                .ToListAsync();

            return Result<List<DepartmentListDTO>>.Success(result);
        }
    }
}
