using Application.Core;
using Domain.ClientDTOs.Profession;
using Domain.ClientDTOs.Team;
using MediatR;

namespace Application
{
    public record CreateTeamCommand(CreateTeamDTO createTeamDTO)
        : IRequest<Result<CreateTeamDTO>>;
}
