using Application;
using Application.Core;
using Application.Queries.Teams;
using Application.Queries.Users;
using Domain.ClientDTOs.Team;
using Domain.DataModels.Notifications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace API.Controllers
{
    public class NotificationController : BaseApiController
    {

        [HttpPost("token")] //.../api/notification/token
        public async Task<IActionResult> StoreNotificationToken(string strUsername, string strNotificationToken)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            strUsername = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(await Mediator.Send(new StoreNotificationTokenCommand(strUsername, strNotificationToken)));
        }
    }
}
