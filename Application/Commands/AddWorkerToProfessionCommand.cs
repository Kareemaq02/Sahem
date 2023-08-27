using Application.Core;
using MediatR;

namespace Application
{
    public record AddWorkerToProfessionCommand(int intWorkerId, int intProfessionId) : IRequest<Result<String>>;
}
