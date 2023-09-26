using Application;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Domain.ClientDTOs.Team
{
    public class SeedTeams
    {
        private readonly DataContext _context;
        private readonly IMediator _mediator;

        public SeedTeams(DataContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public List<TeamMemberDTO> lstTeamMembers { get; set; } = new List<TeamMemberDTO>();

        public async void SeedTeam()
        {
            Random random = new Random();
            var leaders = await _context.Users
                .Where(u => u.intUserTypeId == (int)UsersConstant.userTypes.leader)
                .ToListAsync();
            
            foreach (var leader in leaders)
            {
               var workers = await _context.Users.Where(u => u.intUserTypeId == (int)UsersConstant.userTypes.worker).ToListAsync();
                List<TeamMemberDTO> members = new List<TeamMemberDTO>{ new TeamMemberDTO { intWorkerId = leader.Id, blnIsLeader = true }();
            CreateTeamDTO createTeamDTO = new CreateTeamDTO {strUsername="admin", intDepartmentId= 1, lstTeamMembers = members };
               await _mediator.Send(new CreateTeamCommand(createTeamDTO)));
            }

           
        }

        private static string GenerateRandomUsername()
        {
            // Implement logic to generate a random username
            // You can use a combination of characters, numbers, and random generation
            // For example:
            // Random random = new Random();
            // return "user" + random.Next(1, 1000).ToString();
            throw new NotImplementedException();
        }

        private static List<TeamMemberDTO> GenerateRandomTeamMembers()
        {
            // Implement logic to generate a random list of team members
            // You can create and return a list of TeamMemberDTO objects with random values
            throw new NotImplementedException();
        }
    }
}
