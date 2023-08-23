using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsByUserQuery(string strUserName)
        : IRequest<Result<List<MyComplaintDTO>>>;
}
