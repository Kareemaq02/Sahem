using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Tasks;
using Domain.DataModels.Intersections;
using Domain.ClientDTOs.Task;
using Application;
using Domain.ClientDTOs.Team;

public class EditTeamByIdHandler : IRequestHandler<EditTeamCommand, Result<UpdateTeamDTO>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;

    public EditTeamByIdHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _userManager = userManager;
    }

    public async Task<Result<UpdateTeamDTO>> Handle(
        EditTeamCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.updateTeamDTO.strUsername)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);


        var updateTeamDTO = new UpdateTeamDTO { 
        intTeamId = request.id
        };

        // transaction start...
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
           
                var team = new Team{ intId = request.id };
                _context.Teams.Attach(team);


                var teamCreatorId = await _context.Teams.Where(t => t.intId == request.id).Select(q => q.intAdminId).SingleOrDefaultAsync();
                if (teamCreatorId != userId)
                {
                    return Result<UpdateTeamDTO>.Failure("Only the admin that created the team could edit it");
                }


                if (request.updateTeamDTO.intDepartmentId != 0)
                {
                    team.intDepartmentId = request.updateTeamDTO.intDepartmentId;
                    updateTeamDTO.intDepartmentId = request.updateTeamDTO.intDepartmentId;
                }
                if (request.updateTeamDTO.intNewLeaderID != 0)
                {
                    team.intLeaderId = request.updateTeamDTO.intNewLeaderID;
                    updateTeamDTO.intNewLeaderID = request.updateTeamDTO.intNewLeaderID;
                }
                if (request.updateTeamDTO.lstTeamMembers.Count() != 0)
                {
                var query = from t in _context.Teams
                            join task in _context.Tasks on t.intId equals task.intTeamId
                            where (task.intStatusId == (int)TasksConstant.taskStatus.inProgress
                            || task.intStatusId == (int)TasksConstant.taskStatus.inactive)
                            && t.intId == request.id
                            select new
                            {
                                TaskId = task.intId,
                                StatusId = task.intStatusId
                            };

                var busyTasksCount = await query.CountAsync();

                if (busyTasksCount != 0)
                    return Result<UpdateTeamDTO>.Failure("Cant update a team when a task is still scheduled or in progress");



                   _context.TeamMembers.RemoveRange(_context.TeamMembers
                    .Where(q => q.intTeamId == request.id));

                  await _context.SaveChangesAsync();




                List<TeamMembers> lstTeamMembers = new List<TeamMembers> { };

                foreach (var member in request.updateTeamDTO.lstTeamMembers)
                {
                    lstTeamMembers.Add(new TeamMembers
                    {
                        intTeamId = request.id,
                        intWorkerId = member.intWorkerId
                    });
                    updateTeamDTO.lstTeamMembers.Add(new TeamMemberDTO
                    {
                        intWorkerId = member.intWorkerId,
                        blnIsLeader = member.blnIsLeader
                    });

                }
                await _context.TeamMembers.AddRangeAsync(lstTeamMembers);

            }

                await _context.SaveChangesAsync(cancellationToken);
            
            
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync(cancellationToken);
            return Result<UpdateTeamDTO>.Failure("Failed to update task.");
        }

        await _context.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync();

        return Result<UpdateTeamDTO>.Success(updateTeamDTO);
    }
}
