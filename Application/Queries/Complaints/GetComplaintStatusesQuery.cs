using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintStatusesQuery(int Id) : IRequest<Result<List<ComplaintStatusesDTO>>>;
}
