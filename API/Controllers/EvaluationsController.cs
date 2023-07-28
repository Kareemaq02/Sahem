using Microsoft.AspNetCore.Mvc;
using Application;
using System.IdentityModel.Tokens.Jwt;
using Domain.ClientDTOs.Evaluation;
using Domain.ClientDTOs.Task;

namespace API.Controllers
{
    public class EvaluationsController : BaseApiController
    {
        [HttpPost("complete/{id}")] // .../api/evaluations/complete/...
        public async Task<IActionResult> CompleteTask(EvaluationDTO completedDTO, int id) // Evaluate selected task as completed
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            completedDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;
            return HandleResult(await Mediator.Send(new CompleteTaskCommand(completedDTO, id)));
        }

        [HttpPost("fail/{id}")] // .../api/evaluations/fail/...
        public async Task<IActionResult> FailTask(EvaluationDTO failedDTO, int id) // Evaluate selected task as failed
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            failedDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;
            return HandleResult(await Mediator.Send(new FailTaskCommand(failedDTO, id)));
        }

        [HttpPost("incomplete/{id}")] // .../api/evaluations/incomplete/...
        public async Task<IActionResult> IncompleteTask(IncompleteDTO incompleteDTO, int id) // Evaluate selected task as failed
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            incompleteDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;
            return HandleResult(await Mediator.Send(new IncompleteTaskCommand(incompleteDTO, id)));
        }
    }
}
