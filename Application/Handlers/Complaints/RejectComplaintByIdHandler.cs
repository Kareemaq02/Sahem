using Application.Core;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;

public class RejectComplaintByIdHandler
    : IRequestHandler<RejectComplaintByIdCommand, Result<string>>
{
    private readonly DataContext _context;
    public readonly UserManager<ApplicationUser> _userManager;
    private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

    public RejectComplaintByIdHandler(
        DataContext context,
        UserManager<ApplicationUser> userManager,
        AddComplaintStatusChangeTransactionHandler transactionHandler
    )
    {
        _context = context;
        _userManager = userManager;
        _transactionHandler = transactionHandler;
    }

    public async Task<Result<string>> Handle(
        RejectComplaintByIdCommand request,
        CancellationToken cancellationToken
    )
    {
        var adminId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);


        // transaction start...

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var complaintStatus = await _context.Complaints
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (complaintStatus == (int)ComplaintsConstant.complaintStatus.pending)
            {
                Complaint complaint = new Complaint {intId = request.Id};
                _context.Complaints.Attach(complaint);
                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.rejected;
                complaint.dtmDateLastModified = DateTime.UtcNow;
                complaint.intLastModifiedBy = adminId;

                await  _context.SaveChangesAsync(cancellationToken);

                await _transactionHandler.Handle(
                    new AddComplaintStatusChangeTransactionCommand
                    (request.Id, (int)ComplaintsConstant.complaintStatus.rejected), cancellationToken);
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<string>.Failure("Only pending complaints can be rejected.");
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync();
            return Result<string>.Failure("Failed to update complaint.");
        }
        await transaction.CommitAsync();
        return Result<string>.Success("Complaint rejected.");
    }
}
