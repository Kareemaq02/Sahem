using Application.Core;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Application;
using Domain.DataModels.Intersections;

public class AddComplaintToWatchListHandler
    : IRequestHandler<AddComplaintToWatchListCommand, Result<String>>
{
    private readonly DataContext _context;


    public AddComplaintToWatchListHandler(
        DataContext context
    )
    {
        _context = context;
    }

    public async Task<Result<String>> Handle(
        AddComplaintToWatchListCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.strUserName)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);
   

       var complaintIds = await _context.Complaints
                .Where(c => c.intUserID == userId && c.intId == request.intComplaintId)
                .Select(c => c.intId)
                .CountAsync();

                            //TODO CHANGE IT IN VOTERS TO USE COUNT INSTEAD OF FOREACH
            
                if (complaintIds>=1)
                    return Result<String>.Failure("User can't add their own complaint to watchlist.");
            

        var watchedComplaintIds = await _context.ComplaintWatchers
            .Where(c => c.intUserId == userId && c.intComplaintId == request.intComplaintId)
            .Select(c => c.intComplaintId)
            .CountAsync();

        if (watchedComplaintIds >= 1)
        { 
            return Result<String>.Failure("Complaint is already on your watch list");
        }

        await _context.ComplaintWatchers.AddAsync(
                new ComplaintWatchers
                {
                    intComplaintId = request.intComplaintId,
                    intUserId = userId
                }
            );

            await _context.SaveChangesAsync(cancellationToken);

            return Result<String>.Success("Complaint added to watchlist successfully");

    }
}
