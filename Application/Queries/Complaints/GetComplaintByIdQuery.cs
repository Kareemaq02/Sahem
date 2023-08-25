using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintByIdQuery(int Id)
        : IRequest<Result<ComplaintViewDTO>>;
}
