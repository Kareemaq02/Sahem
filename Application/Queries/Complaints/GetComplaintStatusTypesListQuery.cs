using Application.Core;
using Domain.ClientDTOs.SharedDTOs;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintStatusTypesListQuery() : IRequest<Result<List<StatusDTO>>>;
}
