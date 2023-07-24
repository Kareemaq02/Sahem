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
        : IRequestHandler<GetCitizensListQuery, Result<PagedList<CitizenDTO>>>
    {
        private readonly DataContext _context;

        public GetCitizensListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<CitizenDTO>>> Handle(
            GetCitizensListQuery request,
            CancellationToken cancellationToken
        )
        {
            var queryObject = _context.Users
                .Where(q => q.intUserTypeId == (int)UsersConstant.userTypes.user)
                .OrderBy(q => q.Id)
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
                .AsQueryable();

            var result = await PagedList<CitizenDTO>.CreateAsync(
                queryObject,
                request.pagingParams.PageNumber,
                request.pagingParams.PageSize
            );
            return Result<PagedList<CitizenDTO>>.Success(result);
        }
    }
}
