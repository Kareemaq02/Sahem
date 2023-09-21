using Application.Commands;
using Application.Core;
using Application.Services;
using Domain.ClientDTOs.Team;
using Domain.DataModels.Intersections;
using Domain.DataModels.Notifications;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Teams
{
    public class CreateTeamHandler : IRequestHandler<CreateTeamCommand, Result<CreateTeamDTO>>
    {
        private readonly DataContext _context;
        private readonly IMediator _mediator;
        private readonly NotificationService _notificationService;

        public CreateTeamHandler(
            DataContext context,
            IMediator mediator,
            NotificationService notificationService
        )
        {
            _context = context;
            _mediator = mediator;
            _notificationService = notificationService;
        }

        public async Task<Result<CreateTeamDTO>> Handle(
            CreateTeamCommand request,
            CancellationToken cancellationToken
        )
        {
            var userId = await _context.Users
                .Where(u => u.UserName == request.createTeamDTO.strUsername)
                .Select(u => u.Id)
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);

            List<int> lstMembersIds = request.createTeamDTO.lstTeamMembers
                .Select(q => q.intWorkerId)
                .ToList();

            var blnAtleastOneWorkerIsInAnotherTeam = await _context.TeamMembers.AnyAsync(
                q => lstMembersIds.Contains(q.intWorkerId)
            );

            if (blnAtleastOneWorkerIsInAnotherTeam)
                return Result<CreateTeamDTO>.Failure("One of the workers is already in a team");

            int leaderCount = request.createTeamDTO.lstTeamMembers.Count(
                member => member.blnIsLeader
            );
            if (leaderCount == 0)
                return Result<CreateTeamDTO>.Failure("Leader must be selected");

            if (leaderCount > 1)
                return Result<CreateTeamDTO>.Failure("Only one Leader must be selected");

            //Transaction Begins
            using var transaction = await _context.Database.BeginTransactionAsync();
            if (leaderCount == 1)
            {
                int intLeaderId = request.createTeamDTO.lstTeamMembers
                    .Where(q => q.blnIsLeader == true)
                    .Select(q => q.intWorkerId)
                    .SingleOrDefault();

                try
                {
                    //Teams Table

                    Team newTeam = new Team
                    {
                        intAdminId = userId,
                        intDepartmentId = request.createTeamDTO.intDepartmentId,
                        intLeaderId = intLeaderId,
                    };

                    var newTeamEntity = await _context.AddAsync(newTeam);
                    await _context.SaveChangesAsync(cancellationToken);

                    request.createTeamDTO.intTeamId = newTeamEntity.Entity.intId;

                    //Team Members Table

                    List<TeamMembers> lstTeamMembers = new List<TeamMembers> { };

                    foreach (var member in request.createTeamDTO.lstTeamMembers)
                    {
                        lstTeamMembers.Add(
                            new TeamMembers
                            {
                                intTeamId = newTeamEntity.Entity.intId,
                                intWorkerId = member.intWorkerId
                            }
                        );

                        try
                        {
                            //Insert into Notifications Table

                            var workerId = await _context.Complaints
                                .Where(q => q.intId == member.intWorkerId)
                                .Select(c => c.intUserID)
                                .SingleOrDefaultAsync();

                            var username = await _context.Users
                                .Where(q => q.Id == workerId)
                                .Select(c => c.UserName)
                                .SingleOrDefaultAsync();

                            // Get Notification body and header
                            var notificationLayout = await _context.NotificationTypes
                                .Where(
                                    q =>
                                        q.intId
                                        == (int)
                                            NotificationConstant
                                                .NotificationType
                                                .workerAddedToTeamNotification
                                )
                                .Select(
                                    q =>
                                        new NotificationLayout
                                        {
                                            strHeaderAr = q.strHeaderAr,
                                            strBodyAr = q.strBodyAr,
                                            strBodyEn = q.strBodyEn,
                                            strHeaderEn = q.strHeaderEn
                                        }
                                )
                                .SingleOrDefaultAsync();

                            if (notificationLayout == null)
                                throw new Exception("Notification Type table is empty");

                            string headerAr = notificationLayout.strHeaderAr;
                            string bodyAr =
                                "فريق رقم #"
                                + request.createTeamDTO.intTeamId
                                + " "
                                + notificationLayout.strBodyAr;
                            string headerEn = notificationLayout.strHeaderEn;
                            string strBodyEn =
                                "Team #"
                                + request.createTeamDTO.intTeamId
                                + " "
                                + notificationLayout.strBodyEn;

                            await _mediator.Send(
                                new InsertNotificationCommand(
                                    new Notification
                                    {
                                        intTypeId = (int)
                                            NotificationConstant
                                                .NotificationType
                                                .workerAddedToTeamNotification,
                                        intUserId = workerId,
                                        strHeaderAr = headerAr,
                                        strBodyAr = bodyAr,
                                        strHeaderEn = headerEn,
                                        strBodyEn = strBodyEn,
                                    }
                                )
                            );

                            //await _notificationService.SendNotification(workerId, headerAr, bodyAr);
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e.ToString());
                        }
                    }
                    await _context.TeamMembers.AddRangeAsync(lstTeamMembers);
                    await _context.SaveChangesAsync(cancellationToken);
                }
                catch
                {
                    await transaction.RollbackAsync();
                    return Result<CreateTeamDTO>.Failure("Only one Leader must be selected");
                }
            }
            await transaction.CommitAsync();

            var result = request.createTeamDTO;

            return Result<CreateTeamDTO>.Success(result);
        }
    }
}
