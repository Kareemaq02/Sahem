using Application.Core;
using MediatR;

namespace Application.Queries.Users
{
    public record CheckIfTeamIsAvailableByIdQuery(DateTime startDate, DateTime endDate, int intTeamId) :
        IRequest<Result<bool>>;
}
