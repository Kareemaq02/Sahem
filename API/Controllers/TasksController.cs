using Microsoft.AspNetCore.Mvc;
using Application;
using System.IdentityModel.Tokens.Jwt;
using Domain.ClientDTOs.Task;
using Application.Queries.Tasks;
using Application.Queries.Users;
using Microsoft.AspNetCore.Authorization;
using Application.Handlers.Tasks;
using Application.Commands;

namespace API.Controllers
{
    public class TasksController : BaseApiController
    {
        [HttpGet] // .../api/tasks
        public async Task<IActionResult> GetTasksList()
        {
            return HandleResult(await Mediator.Send(new GetTasksListQuery()));
        }

        [HttpGet("users")] // .../api/tasks/users
        public async Task<IActionResult> GetWorkersList()
        {
            return HandleResult(await Mediator.Send(new GetWorkersListQuery()));
        }

        [HttpPost("types")] // .../api/tasks/types
        public async Task<IActionResult> InsertTaskType([FromForm] TaskTypeDTO taskTypeDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            taskTypeDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertTaskTypeCommand(taskTypeDTO)));
        }

        [HttpGet("types")] //.../api/tasks/types
        public async Task<IActionResult> GetTasksTypesList()
        {
            return HandleResult(await Mediator.Send(new GetTaskTypesListQuery()));
        }

        [HttpPost("{id}")] // .../api/tasks
        public async Task<IActionResult> InsertTaskStats([FromForm] TaskDTO taskDTO, int id) // Create task for selected complaint
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            taskDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertTaskCommand(taskDTO, id)));
        }

        [HttpDelete("delete/{id}")] // .../api/tasks/delete/id
        public async Task<IActionResult> DeleteTasks(int id)
        {
            return HandleResult(await Mediator.Send(new DeleteTaskCommand(id)));
        }

        [Authorize]
        [HttpPut("update/{id}")] // .../api/tasks/update/id
        public async Task<IActionResult> UpdateTask(int id, UpdateTaskDTO updateTaskDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            updateTaskDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new UpdateTaskCommand(updateTaskDTO, id)));
        }
    }
}
