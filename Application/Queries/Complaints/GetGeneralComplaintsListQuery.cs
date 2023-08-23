using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.Helpers;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetGeneralComplaintsListQuery(GeneralComplaintsFilter filter, string strUserName ,
        LatLng userLocation)
        : IRequest<Result<PagedList<GeneralComplaintsListDTO>>>;
}
