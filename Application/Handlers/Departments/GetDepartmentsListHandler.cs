using Application.Core;
using Application.Queries.Departments;
using Domain.ClientDTOs.Department;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Departments
{
    public class GetDepartmentsListHandler
        : IRequestHandler<GetDepartmentsListQuery, Result<List<DepartmentDTO>>>
    {
        private readonly DataContext _context;

        public GetDepartmentsListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<DepartmentDTO>>> Handle(
            GetDepartmentsListQuery request,
            CancellationToken cancellationToken
        )
        {
            List<DepartmentDTO> result = await _context.Departments
                .Select(
                    q =>
                        new DepartmentDTO
                        {
                            strNameAr = q.strNameAr,
                            strNameEn = q.strNameEn,
                        }
                )
                .ToListAsync();

            return Result<List<DepartmentDTO>>.Success(result);
        }
    }
}
