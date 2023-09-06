using Application;
using Application.Commands;
using Application.Core;
using Application.Queries.Tasks;
using Application.Queries.Teams;
using Application.Queries.Users;
using Domain.ClientDTOs.Department;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.Team;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace API.Controllers
{
    public class TeamsController : BaseApiController
    {

        [HttpGet] //.../api/teams
        public async Task<IActionResult> GetTeamsList()
        {
            return HandleResult(await Mediator.Send(new GetTeamsListQuery()));
        }

        [HttpGet("{id}")] //.../api/teams/id
        public async Task<IActionResult> GetTeamById(int id)
        {
            return HandleResult(await Mediator.Send(new GetTeamByIdQuery(id)));
        }

        [HttpPost("Create")] // .../api/teams/Create
        public async Task<IActionResult> CreateTeam(CreateTeamDTO createTeamDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            createTeamDTO.strUsername = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new CreateTeamCommand(createTeamDTO)));
        }

        [HttpGet("workers/WithoutATeam")] //api/teams/workers/withoutATeam
        public async Task<IActionResult> GetWorkersWithNoTeam([FromQuery] PagingParams pagingParams)
        {
            return HandleResult(await Mediator.Send(new GetWorkersWithNoTeamListQuery(pagingParams)));
        }

        [Authorize]
        [HttpPut("edit/{id}")] //.../api/teams/edit/id
        public async Task<IActionResult> UpdateTeam(int id, UpdateTeamDTO updateTeamDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            updateTeamDTO.strUsername = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new EditTeamCommand(id, updateTeamDTO)));
        }

        [HttpGet("available")] //api/teams/available
        public async Task<IActionResult> GetAvailableTeamsList(DateTime startDate, DateTime endDate)
        {
            return HandleResult(await Mediator.Send(new GetAvailableTeamsListQuery(startDate, endDate)));
        }
    }
}
