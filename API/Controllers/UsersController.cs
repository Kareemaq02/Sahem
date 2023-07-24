using API.Services;
using Application;
using Application.Core;
using Application.Queries.Departments;
using Application.Queries.Users;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using Domain.Resources;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.IdentityModel.Tokens;
using Persistence;
using System.IdentityModel.Tokens.Jwt;
using System.Security;
using System.Security.Claims;

namespace API.Controllers
{
    public class UsersController : BaseApiController
    {
        [Authorize]
        [HttpGet("citizens")] // .../api/users/citizens
        public async Task<IActionResult> GetCitizensList([FromQuery] PagingParams pagingParams)
        {
            return HandleResult(await Mediator.Send(new GetCitizensListQuery(pagingParams)));
        }

        [Authorize]
        [HttpGet("{id}")] // .../api/users/id
        public async Task<IActionResult> GetUserInfoById(int id)
        {
            return HandleResult(await Mediator.Send(new GetUserInfoByIdQuery(id)));
        }

        [Authorize]
        [HttpPut("verify/{id}")] //.../api/users/verify/id
        public async Task<IActionResult> VerifyUserById(int id)
        {
            return HandleResult(await Mediator.Send(new VerifyUserByIdCommand(id)));
        }

        [Authorize]
        [HttpPut("unverify/{id}")] //.../api/users/unverify/id
        public async Task<IActionResult> UnverifyUserById(int id)
        {
            return HandleResult(await Mediator.Send(new UnverifyUserByIdCommand(id)));
        }

        [Authorize]
        [HttpPut("blacklist/{id}")] //.../api/users/blacklist/id
        public async Task<IActionResult> BlacklistUserById(int id)
        {
            return HandleResult(await Mediator.Send(new BlacklistUserByIdCommand(id)));
        }

        [Authorize]
        [HttpPut("whitelist/{id}")] //.../api/users/whitelist/id
        public async Task<IActionResult> WhitelistUserById(int id)
        {
            return HandleResult(await Mediator.Send(new WhitelistUserByIdCommand(id)));
        }
    }
}
