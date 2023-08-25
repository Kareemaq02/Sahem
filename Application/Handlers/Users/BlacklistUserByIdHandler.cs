using Application.Core;
using Application;
using MediatR;
using Persistence;
using Domain.Resources;

public class BlacklistUserByIdHandler : IRequestHandler<BlacklistUserByIdCommand, Result<Unit>>
{
    private readonly DataContext _context;

    public BlacklistUserByIdHandler(DataContext context)
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(
        BlacklistUserByIdCommand request,
        CancellationToken cancellationToken
    )
    {
        try
        {
            var user = await _context.Users.FindAsync(request.Id);
            if (user == null)
            {
                return Result<Unit>.Failure("User not found.");
            }
            else if (user.intUserTypeId == (int)UsersConstant.userTypes.admin)
                return Result<Unit>.Failure("The Provided id is not a Citizen or Worker Id");

            if (user.blnIsBlacklisted == false)
            {
                user.blnIsBlacklisted = true;
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<Unit>.Failure("The User with the provided Id is already blacklisted");
        }
        catch (Exception ex)
        {
            return Result<Unit>.Failure($"Failed to blacklist user: {ex.Message}");
        }

        return Result<Unit>.Success(Unit.Value);
    }
}
