using Application.Core;
using Domain.ClientDTOs.Task;
using MediatR;

namespace Application
{
    public record InsertVoteCommand(int intComplaintID, string strUserName) : IRequest<Result<int>>;
}
