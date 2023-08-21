using Application.Core;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;
using Application;
using Domain.DataModels.Intersections;
using Application.Commands;

public class AddComplaintStatusChangeTransactionHandler
    : IRequestHandler<AddComplaintStatusChangeTransactionCommand, Result<String>>
{
    private readonly DataContext _context;


    public AddComplaintStatusChangeTransactionHandler(
        DataContext context
    )
    {
        _context = context;
    }

    public async Task<Result<String>> Handle(
        AddComplaintStatusChangeTransactionCommand request,
        CancellationToken cancellationToken
    )
    {


        await _context.ComplaintsStatuses.AddAsync(
                 new ComplaintsStatuses
                 {
                     intComplaintId = request.complaintId,
                     intStatusId = request.statusId,
                     dtmTransDate = DateTime.UtcNow,
                 }
             );
        await _context.SaveChangesAsync();

        return Result<string>.Success("Transaction added successfully");

    }
}
