using Application.Core;
using Domain.ClientDTOs.Profession;
using Domain.DataModels.LookUps;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Persistence;
using Microsoft.EntityFrameworkCore;

namespace Application.Handlers.LookUps
{
    public class InsertProfessionHandler
        : IRequestHandler<InsertProfessionCommand, Result<ProfessionDTO>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;

        public InsertProfessionHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
        {
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
        }

        public async Task<Result<ProfessionDTO>> Handle(
            InsertProfessionCommand request,
            CancellationToken cancellationToken
        )
        {
            var professionDTO = request.ProfessionDTO;

            if (_context.Professions.Any(p => p.strNameEn == professionDTO.strNameEn
               || p.strNameAr == professionDTO.strNameAr))
            {
                return Result<ProfessionDTO>.Failure("Profession Name Already exists");
            }

            int userId = await _context.Users
                .Where(q => q.UserName == professionDTO.strUserName)
                .Select(q => q.Id)
                .FirstOrDefaultAsync();

            var profession = new Profession
            {
                strNameAr = request.ProfessionDTO.strNameAr,
                strNameEn = request.ProfessionDTO.strNameEn,
                intCreatedBy = userId,
                dtmDateCreated = DateTime.Now,
                intLastModifiedBy = userId,
                dtmDateLastModified = DateTime.Now,
                blnIsDeleted = false
            };

            await _context.Professions.AddAsync(profession, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);



            return Result<ProfessionDTO>.Success(professionDTO);
        }
    }
}
