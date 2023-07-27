using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsListQuery(ComplaintsFilter filter, string strUserName)
        : IRequest<Result<PagedList<ComplaintsListDTO>>>;
}
