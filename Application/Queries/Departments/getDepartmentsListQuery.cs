using Application.Core;
using Domain.ClientDTOs.Department;
using MediatR;

namespace Application.Queries.Departments
{
    public record GetDepartmentsListQuery() : IRequest<Result<List<DepartmentListDTO>>>;
}
