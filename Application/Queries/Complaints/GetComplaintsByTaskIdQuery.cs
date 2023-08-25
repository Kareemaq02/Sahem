using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsByTaskIdQuery(int intTaskId)
        : IRequest<Result<List<ComplaintViewDTO>>>;
}
