using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetWorkerInfoByIdHandler
        : IRequestHandler<GetWorkerInfoByIdQuery, Result<DetailedWorkerDTO>>
    {
        private readonly DataContext _context;

        public GetWorkerInfoByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<DetailedWorkerDTO>> Handle(
            GetWorkerInfoByIdQuery request,
            CancellationToken cancellationToken
        )
        {
            var result = await _context.Users
                .Where(
                    q =>
                        q.Id == request.id && q.intUserTypeId == (int)UsersConstant.userTypes.worker
                )
                .Join(
                    _context.UserInfos,
                    u => u.intUserInfoId,
                    ui => ui.intId,
                    (u, ui) => new { User = u, UserInfo = ui }
                )
                .Select(
                    u =>
                        new DetailedWorkerDTO
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
                            intCompletedTasksCount = _context.TeamMembers.Count(
                                tm => tm.intWorkerId == request.id
                            )
                        }
                )
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return Result<DetailedWorkerDTO>.Failure("Worker not found");
            }

            return Result<DetailedWorkerDTO>.Success(result);
        }
    }
}
