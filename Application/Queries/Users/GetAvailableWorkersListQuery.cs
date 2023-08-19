using Application.Core;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetAvailableWorkersListQuery(DateTime startDate, DateTime endDate) :
        IRequest<Result<List<WorkerDTO>>>;
}
