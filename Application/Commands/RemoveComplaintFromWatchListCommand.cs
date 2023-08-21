using Application.Core;
using MediatR;

namespace Application
{
    public record RemoveComplaintFromWatchListCommand(string strUserName, int intComplaintId) 
        : IRequest<Result<String>>;
}
