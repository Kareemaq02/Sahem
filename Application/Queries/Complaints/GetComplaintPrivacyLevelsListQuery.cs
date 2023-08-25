using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.ClientDTOs.Department;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintPrivacyLevelsListQuery() : IRequest<Result<List<PrivacyLevelsDTO>>>;
}
