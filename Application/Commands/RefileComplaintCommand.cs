using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application
{
    public record RefileComplaintCommand(int ID)
        : IRequest<Result<int>>;
}