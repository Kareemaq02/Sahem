using Application.Core;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;

public class UpdateComplaintByIdHandler
    : IRequestHandler<UpdateComplaintCommand, Result<UpdateComplaintDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public UpdateComplaintByIdHandler(
        DataContext context,
        IConfiguration configuration,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
    }

    public async Task<Result<UpdateComplaintDTO>> Handle(
        UpdateComplaintCommand request,
        CancellationToken cancellationToken
    )
    {
        var userId = await _context.Users
            .Where(u => u.UserName == request.UpdateComplaintDTO.strUserName)
            .Select(u => u.Id)
            .SingleOrDefaultAsync(cancellationToken: cancellationToken);

        var newComplaintComment = request.UpdateComplaintDTO.strComment;
        var newComplaintType = request.UpdateComplaintDTO.strComplaintTypeEn;

        var UpdateComplaintDTO = new UpdateComplaintDTO
        {
            strComment = newComplaintComment,
            strComplaintTypeEn = newComplaintType
        };

        // transaction start...


        try
        {
            var complaintStatus = await _context.Complaints
                .Where(c => c.intId == request.Id)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (complaintStatus == (int)ComplaintsConstant.complaintStatus.pending)
            {
                var complaintTypeId = await _context.ComplaintTypes
                    .Where(c => c.strNameEn == request.UpdateComplaintDTO.strComplaintTypeEn)
                    .Select(c => c.intId)
                    .FirstOrDefaultAsync(cancellationToken);

                var complaint = new Complaint { intId = request.Id };
                _context.Complaints.Attach(complaint);
                complaint.strComment = newComplaintComment;
                complaint.intLastModifiedBy = (int)userId;
                complaint.intTypeId = complaintTypeId;

                await _context.SaveChangesAsync(cancellationToken);
            }
            else
                return Result<UpdateComplaintDTO>.Failure("Failed to update the complaint.");
        }
        catch (DbUpdateException)
        {
            return Result<UpdateComplaintDTO>.Failure("Failed to update complaint.");
        }

        return Result<UpdateComplaintDTO>.Success(UpdateComplaintDTO);
    }
}
