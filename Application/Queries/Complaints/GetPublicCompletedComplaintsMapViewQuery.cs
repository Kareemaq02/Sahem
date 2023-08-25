using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetPublicCompletedComplaintsMapViewQuery()
        : IRequest<Result<List<PublicCompletedComplaintsMapViewDTO>>>;
}
