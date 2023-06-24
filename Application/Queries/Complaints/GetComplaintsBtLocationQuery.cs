using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsBtLocationQuery(LatLng latLng)
        : IRequest<Result<List<ComplaintsListDTO>>>;
}
