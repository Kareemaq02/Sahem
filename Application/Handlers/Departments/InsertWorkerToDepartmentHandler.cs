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

namespace Application.Handlers.LookUps
{
    public class InsertWorkerToDepartmentHandler
        : IRequestHandler<AddWorkerToDepartmentCommand, Result<string>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;

        public InsertWorkerToDepartmentHandler(
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
            AddWorkerToDepartmentCommand request,
            CancellationToken cancellationToken
        )
        {

            if (
                _context.DepartmentUsers.Any(
                    d =>
                        d.intUserId == request.intWorkerId
                        && d.intDepartmentId == request.intDepartmentId
                )
            )
                return Result<string>.Failure("Worker is already in specified department");



            var departmentUser = new DepartmentUsers
            {
                intUserId = request.intWorkerId,
                intDepartmentId = request.intDepartmentId
            };

            await _context.DepartmentUsers.AddAsync(departmentUser, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            return Result<string>.Success("Worker added successfully");
        }
    }
}
