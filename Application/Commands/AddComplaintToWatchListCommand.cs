using Application.Core;
using MediatR;

namespace Application
{
    public record AddComplaintToWatchListCommand(string strUserName,int intComplaintId) : IRequest<Result<String>>;
}
