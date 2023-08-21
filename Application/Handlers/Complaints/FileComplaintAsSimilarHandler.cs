using Application.Core;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Application;


public class FileComplaintAsSimilarHandler
    : IRequestHandler<FileComplaintAsSimilarCommand, Result<String>>
{
    private readonly DataContext _context;
    private readonly IMediator _mediator;

    public FileComplaintAsSimilarHandler(
        DataContext context,
        IMediator mediator
    )
    {
        _context = context;
        _mediator = mediator;
    }

    public async Task<Result<String>> Handle(
        FileComplaintAsSimilarCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.strUserName)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);


        //transaction begins
        using var transaction = await _context.Database.BeginTransactionAsync();

        try
        {

            var addComplaintToWatchlist = new AddComplaintToWatchListCommand(request.strUserName,request.complaintId);
            var addComplaintToWatchlistResult = await _mediator.Send(addComplaintToWatchlist);

           
            try
            {

                var upVoteComplaint = new InsertVoteCommand(request.complaintId, request.strUserName);
                var upVoteComplaintResult = await _mediator.Send(upVoteComplaint);
                Console.WriteLine(upVoteComplaintResult);
                Console.WriteLine(addComplaintToWatchlistResult);

                if (addComplaintToWatchlistResult.IsSuccess && upVoteComplaintResult.IsSuccess)
                {
                    await transaction.CommitAsync();
                    return Result<String>.Success("Complaint submited successfully");
                }
                else
                {
                    return Result<String>.Failure("Failed to submit complaint");
                }
            }
            catch (DbUpdateException)
            {
                await transaction.RollbackAsync();
                return Result<String>.Failure("Failed to submit complaint. "+addComplaintToWatchlistResult.ErrorMessage);
            }
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync();
            return Result<String>.Failure("Failed to submit complaint.");
        }

        

    }
}
