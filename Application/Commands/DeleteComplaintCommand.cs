using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application
{
    public record DeleteComplaintCommand(int Id) : IRequest<Result<Unit>>;
}
