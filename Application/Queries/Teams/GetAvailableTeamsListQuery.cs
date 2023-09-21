using Application.Core;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application.Queries.Users
{
    public record GetAvailableTeamsListQuery(DateTime startDate, DateTime endDate) :
        IRequest<Result<List<TeamListDTO>>>;
}
