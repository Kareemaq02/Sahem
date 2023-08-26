using Application.Core;
using Domain.ClientDTOs.Department;
using Domain.DataModels.LookUps;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Domain.DataModels.Intersections;
using Application.Commands;

namespace Application.Handlers.LookUps
{
    public class RemoveDepartmentByIdHandler
        : IRequestHandler<RemoveDepartmentByIdCommand, Result<string>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;

        public RemoveDepartmentByIdHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
        {
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
        }

        public async Task<Result<string>> Handle(
            RemoveDepartmentByIdCommand request,
            CancellationToken cancellationToken
        )
        {


            var department = new Department
            {
                intId = request.intDepartmentId
            };

            _context.Departments.Attach(department);

            department.blnIsDeleted = true;
            department.dtmDateLastModified = DateTime.UtcNow;
            department.intLastModifiedBy =  await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            await _context.SaveChangesAsync(cancellationToken);

            return Result<string>.Success("Department deleted successfully");
        }
    }
}
