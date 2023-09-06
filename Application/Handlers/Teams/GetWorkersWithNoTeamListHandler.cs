using Application.Core;
using Application.Queries.Teams;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using Domain.Resources;
using MediatR;
using Persistence;

namespace Application.Handlers.Teams
{
    public class GetWorkersWithNoTeamListHandler
        : IRequestHandler<GetWorkersWithNoTeamListQuery, Result<PagedList<WorkerDTO>>>
    {
        private readonly DataContext _context;

        public GetWorkersWithNoTeamListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<WorkerDTO>>> Handle(
            GetWorkersWithNoTeamListQuery request,
            CancellationToken cancellationToken
        )
        {
            var query = from u in _context.Users
                        where u.intUserTypeId == (int)UsersConstant.userTypes.worker &&
                              !_context.TeamMembers.Any(tm => tm.intWorkerId == u.Id)
                        select u;


            var queryObject = query
                .OrderBy(q => q.Id)
                .Select(u =>
                        new WorkerDTO
                        {
                            intId = u.Id,
                            strFirstName = u.UserInfo.strFirstName,
                            strLastName = u.UserInfo.strLastName,
                            strFirstNameAr = u.UserInfo.strFirstNameAr,
                            strLastNameAr = u.UserInfo.strLastNameAr,
                            strPhoneNumber = u.UserInfo.strPhoneNumber
                        }
                )
                .AsQueryable();

            var result = await PagedList<WorkerDTO>.CreateAsync(
                queryObject,
                request.PagingParams.PageNumber,
                request.PagingParams.PageSize
            );

            return Result<PagedList<WorkerDTO>>.Success(result);
        }
    }
}
