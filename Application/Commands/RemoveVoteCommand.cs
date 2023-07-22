using Application.Core;
using MediatR;

namespace Application
{
    public record RemoveVoteCommand(int intComplaintID, string strUserName) : IRequest<Result<int>>;
}
