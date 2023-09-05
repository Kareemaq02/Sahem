using Application.Core;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetAvailableTeamsListQuery(DateTime startDate, DateTime endDate) :
        IRequest<Result<List<TeamDTO>>>;
}
