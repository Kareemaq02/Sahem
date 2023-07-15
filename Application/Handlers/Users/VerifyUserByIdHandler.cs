using Application.Core;
using Application;
using MediatR;
using Persistence;
using Domain.Resources;

public class VerifyUserByIdHandler : IRequestHandler<VerifyUserByIdCommand, Result<Unit>>
{
    private readonly DataContext _context;

    public VerifyUserByIdHandler(DataContext context)
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(VerifyUserByIdCommand request, CancellationToken cancellationToken)
    {
        try
        {
            var user = await _context.Users.FindAsync(request.Id);
            if (user == null)
            {
                return Result<Unit>.Failure("User not found.");
            }
            else if (user.intUserTypeId != (int)UsersConstant.userTypes.user)
                return Result<Unit>.Failure("The Provided id is not a Citizen Id");

            if (user.blnIsVerified == false)
            {
                user.blnIsVerified = true;
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<Unit>.Failure("The User with the provided Id is already verified");
        }
        catch (Exception ex)
        {
            return Result<Unit>.Failure($"Failed to verify user: {ex.Message}");
        }

        return Result<Unit>.Success(Unit.Value);
    }
}