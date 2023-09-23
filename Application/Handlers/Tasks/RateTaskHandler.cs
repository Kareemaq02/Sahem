using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Intersections;
using System.Linq;

public class RateTaskHandler : IRequestHandler<RateTaskCommand, Result<Unit>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;

    public RateTaskHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _userManager = userManager;
    }

    public async Task<Result<Unit>> Handle(
        RateTaskCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var taskId = await _context.TasksComplaints
            .OrderByDescending(q => q.intTaskId)
            .Where(q => q.intComplaintId == request.Id)
            .Select(q => q.intTaskId).FirstOrDefaultAsync();


        //Start transaction
        using var transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
        try
        {
                var blnIsRated = await _context.TaskRatings.Where(q => q.intTaskId == taskId && q.intUserId == userId).AnyAsync();

                if (blnIsRated)
                     return Result<Unit>.Failure("User has already rated that task");

            var updatedTask = await _context.Tasks
                .Where(task => task.intId == taskId)
                .SingleOrDefaultAsync(cancellationToken);



            if (updatedTask.intStatusId == (int)TasksConstant.taskStatus.completed)
                {
                // Add to task rating table

                await _context.TaskRatings.AddAsync(new WorkTaskRating { intTaskId = taskId, intUserId = userId, decRating = request.decRating });

                await _context.SaveChangesAsync(cancellationToken);

                // Update Task Rating
                var intRatersCount = await _context.TaskRatings.Where(q => q.intTaskId == taskId).CountAsync();
                

                updatedTask.decUserRating = ((updatedTask.decUserRating * (intRatersCount - 1)) + request.decRating) / (intRatersCount);

                await _context.SaveChangesAsync(cancellationToken);

                await transaction.CommitAsync();

                return Result<Unit>.Success(Unit.Value);

            }
                else
                    return Result<Unit>.Failure("Task needs to be completed before rating it");

        }
        catch (Exception e)
        {
            await transaction.RollbackAsync();
            return Result<Unit>.Failure("Task rating failed" + e);
        }
    }
}
