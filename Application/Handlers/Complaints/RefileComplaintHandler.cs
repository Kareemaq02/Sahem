using Application.Commands;
using Application.Core;
using Domain.DataModels.Complaints;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class RefileComplaintHandler : IRequestHandler<RefileComplaintCommand, Result<int>>
    {
        private readonly DataContext _context;
        private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

        public RefileComplaintHandler(DataContext context,
            AddComplaintStatusChangeTransactionHandler transactionHandler)
        {
            _transactionHandler = transactionHandler;
            _context = context;
        }

        public async Task<Result<int>> Handle(
            RefileComplaintCommand request,
            CancellationToken cancellationToken
        )
        {
     

            //Start Transaction

            using var transaction = await _context.Database.BeginTransactionAsync(cancellationToken);

            try
            {
                var complaint = new Complaint { intId = request.ID };
                _context.Complaints.Attach(complaint);

                if (complaint.blnIsRefiled == false)
                {
                    
                    complaint.blnIsRefiled = true;

                    await _context.SaveChangesAsync(cancellationToken);
                }
                else
                    return Result<int>.Failure("Can't refile a complaint more than once.");

                if (complaint.intStatusId == (int)ComplaintsConstant.complaintStatus.completed)
                {
                    _context.Complaints.Attach(complaint);
                    complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.refiled;

                    await _context.SaveChangesAsync(cancellationToken);
                }
                else
                    return Result<int>.Failure("Failed to update the complaint. Can't refile incomplete complaint.");

                await _transactionHandler.Handle(
                    new AddComplaintStatusChangeTransactionCommand
                    (
                       request.ID,
                       (int)ComplaintsConstant.complaintStatus.refiled
                    ),
                    cancellationToken
                    );
                await _context.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync();
            }
            catch
            { 
                await transaction.RollbackAsync();
            }

            return Result<int>.Success(request.ID);
        }
    }
}
