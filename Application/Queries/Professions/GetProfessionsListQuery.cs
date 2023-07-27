using Application.Core;
using Domain.ClientDTOs.Profession;
using MediatR;

namespace Application.Queries.Professions
{
    public record GetProfessionsListQuery() : IRequest<Result<List<ProfessionListDTO>>>;
}
