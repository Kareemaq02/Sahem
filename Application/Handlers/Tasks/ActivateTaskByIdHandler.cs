using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Complaints;

public class ActivateTaskByIdHandler : IRequestHandler<ActivateTaskCommand, Result<Unit>>
{
    private readonly DataContext _context;
    private readonly AddComplaintStatusChangeTransactionHandler _addTransactionHandler;
    public readonly UserManager<ApplicationUser> _userManager;

    public ActivateTaskByIdHandler(
        DataContext context,
        AddComplaintStatusChangeTransactionHandler addTransactionHandler,
        UserManager<ApplicationUser> userManager
    )
    {
        _addTransactionHandler = addTransactionHandler;
        _context = context;
        _userManager = userManager;
    }

    public async Task<Result<Unit>> Handle(
        ActivateTaskCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var isLeader = _context.TeamMembers.Any(
            tm => tm.intTeamId == request.Id && tm.intWorkerId == userId && tm.blnIsLeader == true
        );

        //Start transaction
        using var transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
        try
        {
            if (isLeader)
            {
                var task = await _context.Tasks.FindAsync(request.Id);
                if (task.blnIsActivated == false)
                {
                    task.dtmDateActivated = DateTime.UtcNow;
                    task.blnIsActivated = true;
                    task.dtmDateLastModified = DateTime.UtcNow;
                    task.intLastModifiedBy = userId;
                    task.intStatusId = (int)TasksConstant.taskStatus.inProgress;

                    await _context.SaveChangesAsync(cancellationToken);

                    var complaintIds = await _context.TasksComplaints
                        .Where(q => q.intTaskId == request.Id)
                        .Select(q => q.intComplaintId)
                        .ToListAsync();

                    foreach (int complaintId in complaintIds)
                    {
                        var complaint = new Complaint { intId = complaintId };
                        _context.Complaints.Attach(complaint);
                        complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.inProgress;
                        await _context.SaveChangesAsync(cancellationToken);

                        await _addTransactionHandler.Handle(
                            new AddComplaintStatusChangeTransactionCommand(
                                complaintId,
                                (int)ComplaintsConstant.complaintStatus.inProgress
                            ),
                            cancellationToken
                        );
                        await _context.SaveChangesAsync(cancellationToken);
                    }

                    await transaction.CommitAsync();
                    return Result<Unit>.Success(Unit.Value);
                }
                else
                    return Result<Unit>.Failure("Task has already been activated");
            }
            else
                return Result<Unit>.Failure("Only the leader is allowed to activate the task");
        }
        catch
        {
            await transaction.RollbackAsync();
            return Result<Unit>.Failure("Task activation failed");
        }
    }
}
