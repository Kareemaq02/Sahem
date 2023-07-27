using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsByLocationQuery(PagingParams PagingParams, LatLng latLng)
        : IRequest<Result<PagedList<ComplaintsListDTO>>>;
}
