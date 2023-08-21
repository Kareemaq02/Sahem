using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application
{
    public record FileComplaintAsSimilarCommand(string strUserName, int complaintId)
        : IRequest<Result<String>>;
}
