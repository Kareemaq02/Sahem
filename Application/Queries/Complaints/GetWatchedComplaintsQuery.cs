using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetWatchedComplaintsQuery(string strUserName)
        : IRequest<Result<List<WatchedComplaintDTO>>>;
}
