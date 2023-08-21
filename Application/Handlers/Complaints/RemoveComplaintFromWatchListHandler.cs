using Application.Core;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Application;
using Domain.DataModels.Intersections;

public class RemoveComplaintFromWatchListHandler
    : IRequestHandler<RemoveComplaintFromWatchListCommand, Result<String>>
{
    private readonly DataContext _context;


    public RemoveComplaintFromWatchListHandler(
        DataContext context
    )
    {
        _context = context;
    }

    public async Task<Result<String>> Handle(
        RemoveComplaintFromWatchListCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.strUserName)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);


        try
        {
            var complaintWatch = new
                ComplaintWatchers
            {
                intComplaintId = request.intComplaintId,
                intUserId = userId
            };
            _context.ComplaintWatchers.Attach(complaintWatch);
            _context.ComplaintWatchers.Remove(complaintWatch);

            await _context.SaveChangesAsync(cancellationToken);
        }
        catch
        {
            return Result<String>.Failure("Failed to remove complaint from watchlist");

        }
        return Result<String>.Success("Complaint removed from watchlist successfully");

    }
}
