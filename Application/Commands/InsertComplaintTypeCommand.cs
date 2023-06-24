using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;

namespace Application
{
    public record InsertComplaintTypeCommand(InsertComplaintTypeDTO InsertComplaintTypeDTO)
        : IRequest<Result<InsertComplaintTypeDTO>>;
}
