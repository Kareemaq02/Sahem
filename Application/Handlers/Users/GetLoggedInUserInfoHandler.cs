using Application.Core;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Users
{
    public class GetLoggedInUserInfoHandler
        : IRequestHandler<GetLoggedInUserInfoQuery, Result<DetailedUserDTO>>
    {
        private readonly DataContext _context;
        private readonly IMediator _mediator;

        public GetLoggedInUserInfoHandler(DataContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<Result<DetailedUserDTO>> Handle(
            GetLoggedInUserInfoQuery request,
            CancellationToken cancellationToken
        )
        {
            int userId = await _context.Users
                .Where(q => q.UserName == request.strUsername)
                .Select(q => q.Id)
                .SingleOrDefaultAsync();

            var getUserInfo = new GetUserInfoByIdQuery(userId);
            var getUserInfoResult = await _mediator.Send(getUserInfo);


            if (getUserInfoResult.IsSuccess)
            {
                var result = getUserInfoResult.Value;
                return Result<DetailedUserDTO>.Success(result);
            }
            else
            {
                return Result<DetailedUserDTO>.Failure("Invalid user Id");
            }
        }
    }
}

