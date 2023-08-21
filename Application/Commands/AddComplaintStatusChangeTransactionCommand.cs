using Application.Core;
using Application.Handlers.Tasks;
using MediatR;

namespace Application.Commands
{
    public record AddComplaintStatusChangeTransactionCommand
        (int complaintId, int statusId) : IRequest<Result<string>>;
}
