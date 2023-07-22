using Application.Core;
using MediatR;

namespace Application
{
    public record InsertDownVoteCommand(int intComplaintID, string strUserName)
        : IRequest<Result<int>>;
}
