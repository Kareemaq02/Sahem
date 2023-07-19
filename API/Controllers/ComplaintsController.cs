using Microsoft.AspNetCore.Mvc;
using Application;
using Domain.ClientDTOs.Complaint;
using System.IdentityModel.Tokens.Jwt;
using Application.Queries.Complaints;
using Domain.Helpers;
using Application.Commands;

namespace API.Controllers
{
    public class ComplaintsController : BaseApiController
    {
        [HttpGet] // .../api/complaints
        public async Task<IActionResult> GetComplaintsList()
        {
            return HandleResult(await Mediator.Send(new GetComplaintsListQuery()));
        }

        [HttpGet("{id}")] // .../api/complaints/...
        public async Task<IActionResult> GetComplaintById(int id)
        {
            return HandleResult(await Mediator.Send(new GetComplaintByIdQuery(id)));
        }

        [HttpPost("location")] // .../api/complaints/location
        public async Task<IActionResult> GetComplaintsByLocation(LatLng latLng)
        {
            return HandleResult(await Mediator.Send(new GetComplaintsBtLocationQuery(latLng)));
        }

        [HttpPost] // .../api/complaints
        public async Task<IActionResult> InsertComplaint([FromForm] InsertComplaintDTO complaintDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            complaintDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertComplaintCommand(complaintDTO)));
        }

        [HttpGet("user")] // .../api/complaints/user
        public async Task<IActionResult> GetComplaintsByUser()
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);
            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new GetComplaintsByUserQuery(strUserName)));
        }

        [HttpGet("types")] // .../api/complaints/types
        public async Task<IActionResult> GetComplaintTypes()
        {
            return HandleResult(await Mediator.Send(new GetComplaintTypesListQuery()));
        }

        [HttpPost("CreateType")] // .../api/complaints/CreateType
        public async Task<IActionResult> InsertComplaintType([FromForm] InsertComplaintTypeDTO insertComplaintTypeDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            insertComplaintTypeDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertComplaintTypeCommand(insertComplaintTypeDTO)));
        }

        [HttpPost("vote/{intComplaintId}")] // .../api/complaints/vote
        public async Task<IActionResult> InsertVote(int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new InsertVoteCommand(intComplaintId, strUserName))
            );
        }

        [HttpDelete("delete/{id}")] // .../api/complaints/delete/id
        public async Task<IActionResult> DeleteComplaint(int id)
        {
            return HandleResult(await Mediator.Send(new DeleteComplaintCommand(id)));
        }

        [HttpPut("update/{id}")] // .../api/complaints/update/id
        public async Task<IActionResult> UpdateComplaint(int id, UpdateComplaintDTO updateComplaintDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            updateComplaintDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new UpdateComplaintCommand(updateComplaintDTO, id)));
        }




    }
}
