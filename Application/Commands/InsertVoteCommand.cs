using Application.Core;
using MediatR;

namespace Application
{
    public record InsertVoteCommand(int intComplaintID, string strUserName) : IRequest<Result<int>>;
}
