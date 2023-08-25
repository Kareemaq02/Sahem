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
    public class AddWorkerToProfessionHandler
        : IRequestHandler<AddWorkerToProfessionCommand, Result<string>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;

        public AddWorkerToProfessionHandler(
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
            AddWorkerToProfessionCommand request,
            CancellationToken cancellationToken
        )
        {

            if (
                _context.ProfessionUsers.Any(
                    d =>
                        d.intUserId == request.intWorkerId
                        && d.intProfessionId == request.intProfessionId
                )
            )
                return Result<string>.Failure("Worker is already in specified profession");



            var professionUser = new ProfessionUsers
            {
                intUserId = request.intWorkerId,
                intProfessionId = request.intProfessionId
            };

            await _context.ProfessionUsers.AddAsync(professionUser, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);

            return Result<string>.Success("Worker added successfully");
        }
    }
}
