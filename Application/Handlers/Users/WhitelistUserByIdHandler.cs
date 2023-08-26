using Application.Core;
using Application;
using MediatR;
using Persistence;
using Domain.Resources;

public class WhitelistUserByIdHandler : IRequestHandler<WhitelistUserByIdCommand, Result<Unit>>
{
    private readonly DataContext _context;

    public WhitelistUserByIdHandler(DataContext context)
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(
        WhitelistUserByIdCommand request,
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

            if (user.blnIsBlacklisted == true)
            {
                user.blnIsBlacklisted = false;
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<Unit>.Failure("The User with the provided Id is already whitelisted");
        }
        catch (Exception ex)
        {
            return Result<Unit>.Failure($"Failed to whitelist user: {ex.Message}");
        }

        return Result<Unit>.Success(Unit.Value);
    }
}
