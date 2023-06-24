using Microsoft.AspNetCore.Mvc;
using Application;
using System.IdentityModel.Tokens.Jwt;
using Domain.ClientDTOs.Department;
using Application.Queries.Complaints;
using Application.Queries.Departments;

namespace API.Controllers
{
    public class DepartmentsController : BaseApiController
    {
     

        [HttpPost] // .../api/departments
        public async Task<IActionResult> InsertDepartment([FromForm] DepartmentDTO departmentDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            departmentDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertDepartmentCommand(departmentDTO)));
        }
        [HttpGet] // .../api/departments
        public async Task<IActionResult> GetDepartmentsList()
        {
            return HandleResult(await Mediator.Send(new GetDepartmentsListQuery()));
        }


    }
}
