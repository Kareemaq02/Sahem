using Application.Core;
using Domain.ClientDTOs.Profession;
using Domain.ClientDTOs.Task;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application
{
    public record EditTeamCommand(int id, UpdateTeamDTO updateTeamDTO)
        : IRequest<Result<UpdateTeamDTO>>;
}
