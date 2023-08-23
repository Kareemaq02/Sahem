using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetGeneralComplaintsMapViewQuery()
        : IRequest<Result<List<GeneralComplaintsMapViewDTO>>>;
}
