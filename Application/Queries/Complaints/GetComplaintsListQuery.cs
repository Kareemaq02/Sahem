using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using MediatR;

namespace Application.Queries.Complaints
{
    public record GetComplaintsListQuery(PagingParams PagingParams, string strUserName)
        : IRequest<Result<PagedList<ComplaintsListDTO>>>;
}
