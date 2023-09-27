using Application;
using Domain.ClientDTOs.Team;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Seed
{
    public class SeedTeams
    {
        public static async void Seed(DataContext _context, IMediator _mediator)
        {
            var leaders = await _context.Users
                .Where(u => u.intUserTypeId == (int)UsersConstant.userTypes.leader)
                .ToListAsync();

            int pageNumber = 0;
            foreach (var leader in leaders)
            {
                var workers = await _context.Users
                    .Where(u => u.intUserTypeId == (int)UsersConstant.userTypes.worker)
                    .OrderBy(u => u.Id)
                    .Skip(pageNumber * 4)
                    .Take(4)
                    .ToListAsync();

                List<TeamMemberDTO> members = workers
                    .Select(
                        worker => new TeamMemberDTO { intWorkerId = worker.Id, blnIsLeader = false }
                    )
                    .ToList();

                members.Add(new TeamMemberDTO { intWorkerId = leader.Id, blnIsLeader = true });

                CreateTeamDTO createTeamDTO = new CreateTeamDTO
                {
                    strUsername = "admin",
                    intDepartmentId = 1,
                    lstTeamMembers = members
                };
                await _mediator.Send(new CreateTeamCommand(createTeamDTO));

                pageNumber++;
            }
        }
    }
}
