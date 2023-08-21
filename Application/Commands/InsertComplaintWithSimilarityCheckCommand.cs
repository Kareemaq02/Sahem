using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application
{
    public record InsertComplaintWithSimilarityCheckCommand(InsertComplaintDTO ComplaintDTO)
        : IRequest<Result<InsertComplaintDTO>>;
}
