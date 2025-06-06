﻿using Application.Core;
using Application;
using MediatR;
using Persistence;
using Domain.Resources;

public class UnverifyUserByIdHandler : IRequestHandler<UnverifyUserByIdCommand, Result<Unit>>
{
    private readonly DataContext _context;

    public UnverifyUserByIdHandler(DataContext context)
    {
        _context = context;
    }

    public async Task<Result<Unit>> Handle(
        UnverifyUserByIdCommand request,
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

            if (user.blnIsVerified == true)
            {
                user.blnIsVerified = false;
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<Unit>.Failure("The User with the provided Id is already unverified");
        }
        catch (Exception ex)
        {
            return Result<Unit>.Failure($"Failed to verify user: {ex.Message}");
        }

        return Result<Unit>.Success(Unit.Value);
    }
}
