using Microsoft.AspNetCore.Mvc;
using Application;
using System.IdentityModel.Tokens.Jwt;
using Domain.ClientDTOs.Task;
using Application.Queries.Tasks;
using Application.Queries.Users;
using Microsoft.AspNetCore.Authorization;
using Application.Queries.Complaints;
using Application.Commands;
using Application.Core;

namespace API.Controllers
{
    public class TasksController : BaseApiController
    {
        [HttpGet] // .../api/tasks
        public async Task<IActionResult> GetTasksList([FromQuery] TasksFilter filter)
        {
            return HandleResult(await Mediator.Send(new GetTasksListQuery(filter)));
        }

        [HttpGet("users")] // .../api/tasks/users
        public async Task<IActionResult> GetWorkersList([FromQuery] PagingParams pagingParams)
        {
            return HandleResult(await Mediator.Send(new GetWorkersListQuery(pagingParams)));
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

        [HttpPost("{id}")] // .../api/tasks/id
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
        [HttpGet("worker/{id}")] //api/tasks/worker/id
        public async Task<IActionResult> GetWorkerTasks(int id)
        {
            return HandleResult(await Mediator.Send(new GetTasksByWorkerIdQuery(id)));
        }

        [Authorize]
        [HttpGet("details/{id}")] //api/tasks/details/id
        public async Task<IActionResult> GetTaskDetails(int id)
        {
            return HandleResult(await Mediator.Send(new GetTaskDetailsByIdQuery(id)));
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

        [Authorize]
        [HttpPut("activate/{id}")] //.../api/tasks/activate/id
        public async Task<IActionResult> ActivateTask(int id, string username)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            username = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new ActivateTaskCommand(id, username)));
        }

        [HttpPost("submit/{id}")] // .../api/tasks/submit/id
        public async Task<IActionResult> SubmitTask([FromForm] SubmitTaskDTO submitTaskDTO, int id)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            submitTaskDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new SubmitTaskCommand(submitTaskDTO, id)));
        }

        [HttpGet("loggedInWorker")] //api/tasks/loggedInWorker
        public async Task<IActionResult> GetLoggedInWorkerTasks(string username)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            username = jwtToken.Claims.First(c => c.Type == "username").Value;


            return HandleResult(await Mediator.Send(new GetLoggedInWorkerTasksQuery(username)));
        }
    }
}
