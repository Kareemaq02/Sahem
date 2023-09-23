using Application.Core;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;

public class IncrementComplaintReminderHandler
    : IRequestHandler<IncrementComplaintReminderCommand, Result<Unit>>
{
    private readonly DataContext _context;

    public IncrementComplaintReminderHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(
        IncrementComplaintReminderCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var dtmDateLastReminded = await _context.Complaints
            .Where(c => c.intId == request.Id)
            .Select(c => c.dtmDateLastReminded)
            .SingleOrDefaultAsync (cancellationToken: cancellationToken);

        var intReminderCount = await _context.Complaints
            .Where(c => c.intId == request.Id)
            .Select(c => c.intReminder)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        TimeSpan timeSinceLastReminder = DateTime.UtcNow - dtmDateLastReminded;
        if (timeSinceLastReminder.TotalDays >= 2)
        {
            var complaint = new Complaint { intId = request.Id };
            _context.Complaints.Attach(complaint);
            complaint.dtmDateLastReminded = DateTime.UtcNow;
            complaint.dtmDateLastModified = DateTime.UtcNow;
            complaint.intReminder = ++intReminderCount;
            complaint.intLastModifiedBy = userId;

            await _context.SaveChangesAsync(cancellationToken);
        }
        else
        {
            double remainingHours = 48 - timeSinceLastReminder.TotalHours;
            return Result<Unit>.Failure($"يجب عليك الانتظار { (int)Math.Ceiling(remainingHours) } " +
                $"ساعات قبل تذكيرنا بشكوتك مرة أخرى.");
        }
        return Result<Unit>.Success(Unit.Value);
    }
}
