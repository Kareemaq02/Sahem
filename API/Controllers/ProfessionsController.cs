using Microsoft.AspNetCore.Mvc;
using Application;
using System.IdentityModel.Tokens.Jwt;
using Domain.ClientDTOs.Profession;
using Application.Queries.Complaints;
using Application.Queries.Professions;
using Application.Commands;

namespace API.Controllers
{
    public class ProfessionsController : BaseApiController
    {
        [HttpPost] // .../api/professions
        public async Task<IActionResult> InsertDepartment([FromForm] ProfessionDTO professionDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            professionDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertProfessionCommand(professionDTO)));
        }

        [HttpGet] // .../api/professions
        public async Task<IActionResult> GetProfessionsList()
        {
            return HandleResult(await Mediator.Send(new GetProfessionsListQuery()));
        }

        [HttpPost("add/worker")] // .../api/professions/add/worker
        public async Task<IActionResult> AddWorkerToProfession(int intWorkerId, int intProfessionId)
        {
            return HandleResult(await Mediator.Send(new AddWorkerToProfessionCommand(intWorkerId, intProfessionId)));
        }

        [HttpPut("remove")] // .../api/professions/remove
        public async Task<IActionResult> RemoveProfessionById(int intProfessionId) // soft delete
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;
            return HandleResult(await Mediator.Send(new RemoveProfessionByIdCommand(intProfessionId, strUserName)));
        }
    }
}
