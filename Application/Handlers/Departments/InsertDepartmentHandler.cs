using Application.Core;
using Domain.ClientDTOs.Department;
using Domain.DataModels.LookUps;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Persistence;
using Microsoft.EntityFrameworkCore;

namespace Application.Handlers.LookUps
{
    public class InsertDepartmentHandler
        : IRequestHandler<InsertDepartmentCommand, Result<DepartmentDTO>>
    {
        private readonly DataContext _context;
        public readonly UserManager<ApplicationUser> _userManager;

        public InsertDepartmentHandler(
            DataContext context,
            UserManager<ApplicationUser> userManager
        )
        {
            _context = context;
            _userManager = userManager;
        }

        public async Task<Result<DepartmentDTO>> Handle(
            InsertDepartmentCommand request,
            CancellationToken cancellationToken
        )
        {
            var departmentDTO = request.DepartmentDTO;

            if (
                _context.Departments.Any(
                    d =>
                        d.strNameEn == request.DepartmentDTO.strNameEn
                        || d.strNameAr == request.DepartmentDTO.strNameAr
                )
            )
                return Result<DepartmentDTO>.Failure("Department Name Already exists");

            int userId = await _context.Users
                .Where(q => q.UserName == departmentDTO.strUserName)
                .Select(q => q.Id)
                .FirstOrDefaultAsync();

            var department = new Department
            {
                strNameAr = request.DepartmentDTO.strNameAr,
                strNameEn = request.DepartmentDTO.strNameEn,
                intCreatedBy = userId,
                dtmDateCreated = DateTime.Now,
                intLastModifiedBy = userId,
                dtmDateLastModified = DateTime.Now,
                blnIsDeleted = false
            };

            await _context.Departments.AddAsync(department, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            return Result<DepartmentDTO>.Success(departmentDTO);
        }
    }
}
