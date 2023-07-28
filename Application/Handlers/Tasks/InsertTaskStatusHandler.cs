using Application.Core;
using Application;
using Domain.ClientDTOs.Task;
using MediatR;
using Persistence;
using Domain.DataModels.Tasks;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;

public class InsertTaskStatusHandler
    : IRequestHandler<InsertTaskStatusCommand, Result<TaskStatusDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;

    public InsertTaskStatusHandler(
        DataContext context,
        IConfiguration configuration,
        UserManager<ApplicationUser> userManager
    )
    {
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
    }

    public async Task<Result<TaskStatusDTO>> Handle(
        InsertTaskStatusCommand request,
        CancellationToken cancellationToken
    )
    {
        var taskStatusDTO = request.TaskStatusDTO;

        var taskStatus = new WorkTaskStatus { strName = request.TaskStatusDTO.strName };

        await _context.TaskStatus.AddAsync(taskStatus, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);

        return Result<TaskStatusDTO>.Success(taskStatusDTO);
    }
}
