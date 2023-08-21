using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsAnalyticsQuery(ComplaintsFilter filter)
        : IRequest<Result<List<ComplaintsAnalyticsDTO>>>;
}
