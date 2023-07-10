using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application.Commands
{
    public record UpdateComplaintCommand(UpdateComplaintDTO UpdateComplaintDTO, int Id)
        : IRequest<Result<UpdateComplaintDTO>>;
}
