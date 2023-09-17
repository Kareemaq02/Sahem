using Application.Core;
using Domain.ClientDTOs.Profession;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application
{
    public record GiveWorkeraVacationCommand(int id, DateTime dtmDateFrom, DateTime dtmDateTo)
        : IRequest<Result<string>>;
}
