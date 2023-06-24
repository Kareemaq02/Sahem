using Application.Core;
using Application;
using Domain.ClientDTOs.Complaint;
using MediatR;
using Persistence;
using Domain.DataModels.Complaints;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;

public class InsertComplaintTypeHandler : IRequestHandler<InsertComplaintTypeCommand, Result<InsertComplaintTypeDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public InsertComplaintTypeHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager
        )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;

    }

    public async Task<Result<InsertComplaintTypeDTO>> Handle(InsertComplaintTypeCommand request, CancellationToken cancellationToken)
    {

        var insertComplaintTypeDTO = request.InsertComplaintTypeDTO;

        var user = await _userManager.FindByNameAsync(insertComplaintTypeDTO.strUserName);
        int userId = await _context.Users
               .Where(q => q.UserName == insertComplaintTypeDTO.strUserName)
               .Select(q => q.Id)
               .FirstOrDefaultAsync();

        var complaintType = new ComplaintType
        {
            intDepartmentId = insertComplaintTypeDTO.intDepartmentId,
            strNameAr = insertComplaintTypeDTO.strNameAr,
            strNameEn = insertComplaintTypeDTO.strNameEn,
            decGrade = insertComplaintTypeDTO.decGrade,
            intPrivacyId = insertComplaintTypeDTO.intPrivacyId,
            intCreatedBy = user.Id,
            dtmDateCreated = DateTime.Now,
            intLastModifiedBy = user.Id,
            dtmDateLastModified = DateTime.Now,
            blnIsDeleted = false
        };

        await _context.ComplaintTypes.AddAsync(complaintType, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);



        return Result<InsertComplaintTypeDTO>.Success(insertComplaintTypeDTO);
    }
}
