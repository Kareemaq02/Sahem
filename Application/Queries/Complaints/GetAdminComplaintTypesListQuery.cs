using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetAdminComplaintTypesListQuery(string strUsername) : IRequest<Result<List<ComplaintTypeDTO>>>;
}
