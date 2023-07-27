using Application.Core;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.DataModels.Tasks;
using Domain.Resources;

public class ActivateTaskByIdHandler : IRequestHandler<ActivateTaskCommand, Result<Unit>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public ActivateTaskByIdHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
    }

    public async Task<Result<Unit>> Handle(ActivateTaskCommand request, CancellationToken cancellationToken)
    {
        var userId = await _context.Users
               .Where(u => u.UserName == request.username)
               .Select(u => u.Id)
               .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var isLeader = _context.TaskMembers.Any(tm => tm.intTaskId == request.Id && tm.intWorkerId == userId
        && tm.blnIsLeader == true);



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
                return Result<Unit>.Success(Unit.Value);
            }
            else
                return Result<Unit>.Failure("Task has already been activated");
        }
        else
            return Result<Unit>.Failure("Only the leader is allowed to activate the task");
    }
}