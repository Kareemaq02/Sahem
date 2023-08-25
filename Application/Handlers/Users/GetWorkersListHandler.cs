using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Users
{
    public class GetWorkersListHandler
        : IRequestHandler<GetWorkersListQuery, Result<PagedList<WorkerDTO>>>
    {
        private readonly DataContext _context;

        public GetWorkersListHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<PagedList<WorkerDTO>>> Handle(
            GetWorkersListQuery request,
            CancellationToken cancellationToken
        )
        {
            var queryObject = _context.Users
                .Where(q => q.intUserTypeId == 2)
                .OrderBy(q => q.Id)
                .Join(
                    _context.UserInfos,
                    u => u.Id,
                    ui => ui.intId,
                    (u, ui) =>
                        new WorkerDTO
                        {
                            intId = u.Id,
                            strFirstName = ui.strFirstName,
                            strLastName = ui.strLastName,
                            strFirstNameAr = ui.strFirstNameAr,
                            strLastNameAr = ui.strLastNameAr,
                            strPhoneNumber = ui.strPhoneNumber
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
