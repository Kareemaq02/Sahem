using Application.Core;
using Domain.DataModels.User;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class RemoveVoteHandler : IRequestHandler<RemoveVoteCommand, Result<int>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;

        public RemoveVoteHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
        {
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
        }

        public async Task<Result<int>> Handle(
            RemoveVoteCommand request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            var complaintVote = await _context.ComplaintVoters.FirstOrDefaultAsync(
                cv => cv.intUserId == userId && cv.intComplaintId == request.intComplaintID
            );

            _context.ComplaintVoters.Remove(complaintVote);
            await _context.SaveChangesAsync();

            return Result<int>.Success(request.intComplaintID);
        }
    }
}
