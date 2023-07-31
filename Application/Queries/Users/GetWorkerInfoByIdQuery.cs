using Application.Core;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using MediatR;

namespace Application.Queries.Users
{
    public record GetWorkerInfoByIdQuery(int id) : IRequest<Result<DetailedWorkerDTO>>;
}
