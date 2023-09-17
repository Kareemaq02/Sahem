using Application.Core;
using MediatR;
using Persistence;
using Microsoft.EntityFrameworkCore;

namespace Application.Handlers.Teams
{
    public class GiveWorkerAVacationHandler
        : IRequestHandler<GiveWorkeraVacationCommand, Result<string>>
    {
        private readonly DataContext _context;

        public GiveWorkerAVacationHandler(DataContext context)
        {
            _context = context;
        }

        public async Task<Result<string>> Handle(
            GiveWorkeraVacationCommand request,
            CancellationToken cancellationToken
        )
        {
            DateTime startDate = request.dtmDateFrom;
            DateTime endDate = request.dtmDateTo;
            
    
            var intTeamId = await
                _context.Teams.Where(q => q.intLeaderId == request.id).Select(q => q.intId).FirstOrDefaultAsync();

            if (intTeamId != 0)
            {
                var busyTeamIdsQuery =
                from teams in _context.Teams
                join t in _context.Tasks on teams.intId equals t.intTeamId
                where !(
                        t.dtmDateDeadline > endDate && t.dtmDateScheduled > endDate
                        || t.dtmDateDeadline < startDate && t.dtmDateScheduled < startDate
                    ) && t.intTeamId == intTeamId
                select teams.intId;


                if (await busyTeamIdsQuery.CountAsync() == 0)
                {
                    await _context.WorkerVacations.AddAsync(new Domain.DataModels.Complaints.WorkerVacation
                    {
                        intWorkerId = request.id,
                        dtmStartDate = request.dtmDateFrom,
                        dtmEndDate = request.dtmDateTo,
                    });
                    await _context.SaveChangesAsync();

                    return Result<string>.Success("Vacation given to leader");
                }
                else
                    return Result<string>.Success("Leader has a scheduled or an active task at the selected dates");


            }
            else
            {
                await _context.WorkerVacations.AddAsync(new Domain.DataModels.Complaints.WorkerVacation
                {
                    intWorkerId = request.id,
                    dtmStartDate = request.dtmDateFrom,
                    dtmEndDate = request.dtmDateTo,
                });

                await _context.SaveChangesAsync();

                return Result<string>.Success("Vacation given to worker.");

            }
            

            
        }
    }
}
