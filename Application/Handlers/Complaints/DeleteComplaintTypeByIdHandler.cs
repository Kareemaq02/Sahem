using Application.Core;
using Domain.DataModels.Complaints;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;

namespace Application.Handlers
{
    public class DeleteComplaintTypeByIdHandler : IRequestHandler<DeleteComplaintTypeByIdCommand, Result<string>>
    {
        private readonly DataContext _context;

        public DeleteComplaintTypeByIdHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<string>> Handle(
            DeleteComplaintTypeByIdCommand request,
            CancellationToken cancellationToken
        )
        {
            var adminId = await _context.Users
            .Where(u => u.UserName == request.username)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            ComplaintType complaintType = new ComplaintType { intId = request.Id };
            _context.ComplaintTypes.Attach(complaintType);
            complaintType.blnIsDeleted = true;
            complaintType.dtmDateLastModified = DateTime.UtcNow;
            complaintType.intLastModifiedBy = adminId;

            await _context.SaveChangesAsync(cancellationToken);
            return Result<string>.Success("Complaint type deleted.");
        }
    }
}
