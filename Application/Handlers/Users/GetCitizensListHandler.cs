using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;
using Domain.Resources;

namespace Application.Handlers.Users
{
    public class GetCitizensListHandler
        : IRequestHandler<GetCitizensListQuery, Result<List<CitizenDTO>>>
    {
        private readonly DataContext _context;

        public GetCitizensListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<List<CitizenDTO>>> Handle(
            GetCitizensListQuery request,
            CancellationToken cancellationToken
        )
        {
            List<CitizenDTO> result = await _context.Users
                .Where(q => q.intUserTypeId == (int)UsersConstant.userTypes.user)
                .Join(
                    _context.UserInfos,
                    u => u.Id,
                    ui => ui.intId,
                    (u, ui) =>
                        new CitizenDTO
                        {
                            intId = u.Id,
                            strFirstName = ui.strFirstName,
                            strLastName = ui.strLastName,
                            strUsername = u.UserName,
                            boolIsActive = u.blnIsActive,
                            boolIsVerified = u.blnIsVerified,
                            boolIsBlacklisted = u.blnIsBlacklisted
                        }
                )
                .ToListAsync();
            return Result<List<CitizenDTO>>.Success(result);
        }
    }
}
