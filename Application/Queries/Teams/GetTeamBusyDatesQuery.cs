using Application.Core;
using Domain.Helpers;
using MediatR;

namespace Application.Queries.Teams
{
    public record GetTeamBusyDatesQuery(int intTeamId) : IRequest<Result<List<DateRange>>>;
}
