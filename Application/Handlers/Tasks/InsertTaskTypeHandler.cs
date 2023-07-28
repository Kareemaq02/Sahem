using Application.Core;
using Application;
using Domain.ClientDTOs.Task;
using MediatR;
using Persistence;
using Domain.DataModels.Tasks;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;

public class InsertTaskTypeHandler : IRequestHandler<InsertTaskTypeCommand, Result<TaskTypeDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public InsertTaskTypeHandler(
        DataContext context,
        IConfiguration configuration,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
    }

    public async Task<Result<TaskTypeDTO>> Handle(
        InsertTaskTypeCommand request,
        CancellationToken cancellationToken
    )
    {
        var taskTypeDTO = request.TaskTypeDTO;

        var user = await _userManager.FindByNameAsync(taskTypeDTO.strUserName);
        int userId = user.Id;
        var taskType = new WorkTaskType
        {
            intDepartmentId = request.TaskTypeDTO.intDepartmentId,
            strNameAr = request.TaskTypeDTO.strNameAr,
            strNameEn = request.TaskTypeDTO.strNameEn,
            intCreatedBy = user.Id,
            dtmDateCreated = DateTime.Now,
            intLastModifiedBy = user.Id,
            dtmDateLastModified = DateTime.Now,
            blnIsDeleted = false
        };

        await _context.TaskTypes.AddAsync(taskType, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<TaskTypeDTO>.Success(taskTypeDTO);
    }
}
