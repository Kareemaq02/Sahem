﻿using Application;
using Application.Core;
using Application.Handlers.Teams;
using Application.Queries.Teams;
using Application.Queries.Users;
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

        [HttpGet("leader/{id}")] //.../api/teams/leader/id
        public async Task<IActionResult> GetTeamByLeaderId(int id)
        {
            return HandleResult(await Mediator.Send(new GetTeamByLeaderIdQuery(id)));
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
            return HandleResult(
                await Mediator.Send(new GetWorkersWithNoTeamListQuery(pagingParams))
            );
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
            return HandleResult(
                await Mediator.Send(new GetAvailableTeamsListQuery(startDate, endDate))
            );
        }

        [HttpGet("available/{id}")] //api/teams/available/id
        public async Task<IActionResult> CheckIfTeamIsAvailable(
            DateTime startDate,
            DateTime endDate,
            int id
        )
        {
            return HandleResult(
                await Mediator.Send(new CheckIfTeamIsAvailableByIdQuery(startDate, endDate, id))
            );
        }

        [HttpGet("busydates/{id}")] //api/teams/busydates/id
        public async Task<IActionResult> GetTeamBusyDates(int id)
        {
            return HandleResult(await Mediator.Send(new GetTeamBusyDatesQuery(id)));
        }

        [HttpPost("worker/vacation/{id}")] //api/teams/worker/vacation/id
        public async Task<IActionResult> GiveWorkeraVacation(
            int id,
            DateTime dtmDateFrom,
            DateTime dtmDateTo
        )
        {
            return HandleResult(
                await Mediator.Send(new GiveWorkeraVacationCommand(id, dtmDateFrom, dtmDateTo))
            );
        }

        [HttpGet("admin")] //api/teams/admin
        public async Task<IActionResult> GetLoggedInAdminTeamsList(string strUsername)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            strUsername = jwtToken.Claims.First(c => c.Type == "username").Value;
            return HandleResult(await Mediator.Send(new GetLoggedInAdminTeamsQuery(strUsername)));
        }

        [HttpGet("analytics/{id}")] //api/teams/analytics/id
        public async Task<IActionResult> GetTeamAnalyticsById(
            int id,
            [FromQuery] FromTo_DateFilter filter
        )
        {
            return HandleResult(await Mediator.Send(new GetTeamAnalyticsByIdQuery(filter, id)));
        }

        [HttpGet("loggedin/analytics")] //api/teams/loggedin/analytics
        public async Task<IActionResult> GetLoggedInTeamAnalytics(
            [FromQuery] FromTo_DateFilter filter
        )
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUsername = jwtToken.Claims.First(c => c.Type == "username").Value;

            return HandleResult(
                await Mediator.Send(new GetLoggedInTeamAnaylticsQuery(filter, strUsername))
            );
        }
    }
}
