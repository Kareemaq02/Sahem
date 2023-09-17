using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetUserInfoByIdHandler
        : IRequestHandler<GetUserInfoByIdQuery, Result<DetailedUserDTO>>
    {
        private readonly DataContext _context;

        public GetUserInfoByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<DetailedUserDTO>> Handle(
            GetUserInfoByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var result = await _context.Users
                .Where(q => q.Id == request.id)
                .Join(
                    _context.UserInfos,
                    u => u.intUserInfoId,
                    ui => ui.intId,
                    (u, ui) => new { User = u, UserInfo = ui }
                )
                .Select(
                    u =>
                        new DetailedUserDTO
                        {
                            intId = u.User.Id,
                            strUsername = u.User.UserName,
                            strFirstName = u.UserInfo.strFirstName,
                            strLastName = u.UserInfo.strLastName,
                            strNationalId = u.UserInfo.strNationalId,
                            strPhoneNumber = u.UserInfo.strPhoneNumber,
                            strNationalIdNumber = u.UserInfo.strNationalIdNumber,
                            strPassportNumber = u.UserInfo.strPassportNumber,
                            strRegistrationNumber = u.UserInfo.strRegistrationNumber,
                            boolIsActive = u.User.blnIsActive,
                            boolIsBlacklisted = u.User.blnIsBlacklisted,
                            boolIsVerified = u.User.blnIsVerified,
                            strFirstNameAr = u.UserInfo.strFirstNameAr,
                            strLastNameAr = u.UserInfo.strLastNameAr,
                        }
                )
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return Result<DetailedUserDTO>.Failure("User not found");
            }

            return Result<DetailedUserDTO>.Success(result);
        }
    }
}
