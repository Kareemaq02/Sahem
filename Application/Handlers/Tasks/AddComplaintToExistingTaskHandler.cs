using Application.Core;
using MediatR;
using Persistence;
using Microsoft.AspNetCore.Identity;
using Domain.DataModels.User;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Application.Commands;
using Domain.Resources;
using Domain.DataModels.Tasks;
using Domain.DataModels.Intersections;
using Domain.ClientDTOs.Task;
using System.Linq;
using Domain.DataModels.Complaints;

public class AddComplaintToExistingTaskHandler :
    IRequestHandler<AddComplaintToExistingTaskCommand, Result<AddComplaintToExistingTaskDTO>>
{
    private readonly DataContext _context;
    private readonly IConfiguration _configuration;
    public readonly UserManager<ApplicationUser> _userManager;
    private readonly AddComplaintStatusChangeTransactionHandler _changeTransactionHandler;

    public AddComplaintToExistingTaskHandler(
        AddComplaintStatusChangeTransactionHandler changeTransactionHandler,
        DataContext context,
        IConfiguration configuration,
        UserManager<ApplicationUser> userManager
    )
    {
        _changeTransactionHandler = changeTransactionHandler;
        _context = context;
        _configuration = configuration;
        _userManager = userManager;
    }

    public async Task<Result<AddComplaintToExistingTaskDTO>> Handle(
        AddComplaintToExistingTaskCommand request,
        CancellationToken cancellationToken
    )
    { 
      
        var AddComplaintToExistingTaskDTO = request.addComplaintToTaskDTO;

        // transaction start...
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var taskStatus = await _context.Tasks
                .Where(c => c.intId == AddComplaintToExistingTaskDTO.taskId)
                .Select(c => c.intStatusId)
                .FirstOrDefaultAsync(cancellationToken);

            if (
                taskStatus == (int)TasksConstant.taskStatus.inactive
            )
            {
                var task = new WorkTask { intId = AddComplaintToExistingTaskDTO.taskId };
                _context.Tasks.Attach(task);

                var multiCount = await _context.TasksComplaints
                    .Where(t => t.intTaskId == AddComplaintToExistingTaskDTO.taskId).Select
                    (t => t.intTaskId).CountAsync();



                if (multiCount == 1)
                {
                    task.intTypeId = (int)TasksConstant.taskType.multiType;

                }
                else if (multiCount == 0)
                {
                    await transaction.RollbackAsync();
                    return Result<AddComplaintToExistingTaskDTO>
                    .Failure("The task doesnt exist");
                }   
                
                
                   
                await _context.SaveChangesAsync(cancellationToken);
            }
            else
            {
                return Result<AddComplaintToExistingTaskDTO>
                    .Failure("Task needs to be inactive.");
            }
        }
        catch (DbUpdateException)
        {
            await transaction.RollbackAsync();
            return Result<AddComplaintToExistingTaskDTO>.Failure("Failed to update task.");
        }

        try
        {

            foreach (var complaintId in AddComplaintToExistingTaskDTO.lstComplaintsIds)
            {
                Complaint complaint = new Complaint { intId = complaintId };

                _context.Complaints.Attach(complaint);

                complaint.intStatusId = (int)ComplaintsConstant.complaintStatus.Scheduled;

                await _context.SaveChangesAsync(cancellationToken);

                await _changeTransactionHandler.Handle(
                new
                (
                    complaintId,
                    (int)ComplaintsConstant.complaintStatus.Scheduled
                    ), cancellationToken
                );

                await _context.SaveChangesAsync(cancellationToken);

                _context.TasksComplaints.Add(new WorkTaskComplaints
                {
                    intComplaintId = complaintId,
                    intTaskId = AddComplaintToExistingTaskDTO.taskId
                });
                await _context.SaveChangesAsync(cancellationToken);
            }

          
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            return Result<AddComplaintToExistingTaskDTO>.Failure("Unknown Error");
        }

       
   
        await transaction.CommitAsync();

        return Result<AddComplaintToExistingTaskDTO>.Success(AddComplaintToExistingTaskDTO);
    }
}
