using Microsoft.AspNetCore.Mvc;
using Application;
using Domain.ClientDTOs.Complaint;
using System.IdentityModel.Tokens.Jwt;
using Application.Queries.Complaints;
using Domain.Helpers;
using Microsoft.AspNetCore.Authorization;
using Application.Commands;
using Application.Core;
using Domain.DataModels.Complaints;

namespace API.Controllers
{
    public class ComplaintsController : BaseApiController
    {
        [HttpGet] // .../api/complaints
        public async Task<IActionResult> GetComplaintsList([FromQuery] ComplaintsFilter filter,
            bool blnIncludePictures)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new GetComplaintsListQuery(filter, strUserName, blnIncludePictures))
            );
        }

        [HttpGet("analytics")] // .../api/complaints
        public async Task<IActionResult> GetComplaintsAnalytics([FromQuery] ComplaintsFilter filter)
        {
            return HandleResult(
                await Mediator.Send(new GetComplaintsAnalyticsQuery(filter))
            );
        }

        [HttpGet("mywatchlist")] // .../api/complaints/mywatchlist
        public async Task<IActionResult> GetWatchedComplaintsList()
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new GetWatchedComplaintsQuery(strUserName))
            );
        }

        [HttpGet("{id}")] // .../api/complaints/...
        public async Task<IActionResult> GetComplaintById(int id)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new GetComplaintByIdQuery(strUserName, id)));
        }

        [HttpPost("location")] // .../api/complaints/location
        public async Task<IActionResult> GetComplaintsByLocation(
            [FromQuery] PagingParams pagingParams,
            LatLng latLng
        )
        {
            return HandleResult(
                await Mediator.Send(new GetComplaintsByLocationQuery(pagingParams, latLng))
            );
        }

        [HttpPost] // .../api/complaints   //use in case user declines the similarity popup
        public async Task<IActionResult> InsertComplaint([FromForm] InsertComplaintDTO complaintDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            complaintDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertComplaintCommand(complaintDTO)));
        }

        [HttpPost("similarComplaintCheck")] // .../api/complaints/similarComplaintCheck
        //use on the first time the user clicks insert complaint
        public async Task<IActionResult> InsertComplaintWithSimilarityCheck
            ([FromForm] InsertComplaintDTO complaintDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            complaintDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new InsertComplaintWithSimilarityCheckCommand(complaintDTO)));
        }

        [HttpPost("upvote/addToWatchList/similar/{intComplaintId}")]
        // .../api/complaints/upvote/addToWatchList/similar/(id goes here)
        //use on the first time the user clicks insert complaint
        public async Task<IActionResult> FileComplaintAsSimilar(int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new FileComplaintAsSimilarCommand(strUserName, intComplaintId)));
        }


        [HttpPut("refile")] // .../api/complaints/refile
        public async Task<IActionResult> RefileComplaint(int ID)
        {
            return HandleResult(await Mediator.Send(new RefileComplaintCommand(ID)));
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
        public async Task<IActionResult> InsertComplaintType(
            [FromForm] InsertComplaintTypeDTO insertComplaintTypeDTO
        )
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            insertComplaintTypeDTO.strUserName = jwtToken.Claims
                .First(c => c.Type == "username")
                .Value;

            return HandleResult(
                await Mediator.Send(new InsertComplaintTypeCommand(insertComplaintTypeDTO))
            );
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

        [HttpPost("votedown/{intComplaintId}")] // .../api/complaints/vote
        public async Task<IActionResult> InsertDonwVote(int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new InsertDownVoteCommand(intComplaintId, strUserName))
            );
        }

        [HttpPost("voteremove/{intComplaintId}")] // .../api/complaints/voteremove/...
        public async Task<IActionResult> RemoveVote(int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new RemoveVoteCommand(intComplaintId, strUserName))
            );
        }

        [HttpDelete("delete/{id}")] // .../api/complaints/delete/id
        public async Task<IActionResult> DeleteComplaint(int id)
        {
            return HandleResult(await Mediator.Send(new DeleteComplaintCommand(id)));
        }

        [Authorize]
        [HttpGet("completed/public")] // .../api/complaints/completed/public
        public async Task<IActionResult> GetCompletedComplaintsUser()
        {
            return HandleResult(await Mediator.Send(new GetCompletedComplaintsUserQuery()));
        }

        [Authorize]
        [HttpGet("completed/all")] // .../api/complaints/completed/all
        public async Task<IActionResult> GetCompletedComplaintsAdmin()
        {
            return HandleResult(await Mediator.Send(new GetCompletedComplaintsAdminQuery()));
        }

        [HttpPut("update/{id}")] // .../api/complaints/update/id
        public async Task<IActionResult> UpdateComplaint(
            int id,
            UpdateComplaintDTO updateComplaintDTO
        )
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            updateComplaintDTO.strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new UpdateComplaintCommand(updateComplaintDTO, id))
            );
        }

        [HttpGet("statuses/{id}")] // .../api/complaints/statuses/id
        public async Task<IActionResult> GetComplaintStatuses(int id)
        {
            return HandleResult(await Mediator.Send(new GetComplaintStatusesQuery(id)));
        }

        [HttpPut("remind/{id}")] // .../api/complaints/remind/id
        public async Task<IActionResult> IncrementComplaintReminder(
            int id,
            string username
        )
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            username = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new IncrementComplaintReminderCommand(id, username))
            );
        }

    
        [HttpGet("status/list")] // .../api/complaints/status/list
        public async Task<IActionResult> GetComplaintStatusTypes()
        {
            return HandleResult(await Mediator.Send(new GetComplaintStatusTypesListQuery()));
        }


        [HttpPost("addToWatchlist/{intComplaintId}")] // .../api/complaints/addToWatchlist
        public async Task<IActionResult> AddComplaintToWatchList
            (int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new AddComplaintToWatchListCommand(strUserName,intComplaintId)));
        }

        [HttpDelete("removeFromWatchList/{intComplaintId}")] // .../api/complaints/removeFromWatchList
        public async Task<IActionResult> RemoveComplaintFromWatchList
            (int intComplaintId)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            string strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new RemoveComplaintFromWatchListCommand(strUserName, intComplaintId)));
        }



    }
}
