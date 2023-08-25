using Application.Core;
using Application.Queries.Complaints;
using Domain.ClientDTOs.Complaint;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace Application.Handlers.Complaints
{
    public class GetComplaintsByTaskIdHandler
        : IRequestHandler<GetComplaintsByTaskIdQuery, Result<List<ComplaintViewDTO>>>
    {
        private readonly DataContext _context;
        private readonly GetComplaintByIdHandler _getComplaintByIdHandler;

        public GetComplaintsByTaskIdHandler(DataContext context, GetComplaintByIdHandler getComplaintByIdHandler)
        {
            _context = context;
            _getComplaintByIdHandler = getComplaintByIdHandler;
        }

        public async Task<Result<List<ComplaintViewDTO>>> Handle(
            GetComplaintsByTaskIdQuery request,
            CancellationToken cancellationToken
        )
        {

            var query =
                from c in _context.Complaints
                join ct in _context.TasksComplaints on c.intId equals ct.intComplaintId
                where ct.intTaskId == request.intTaskId
                select new
                {
                    intComplaintId = c.intId
                };


            var complaintsIds = await query
                .AsNoTracking()
                .Select(
                    c => c.intComplaintId
                )
                .ToListAsync(cancellationToken);

            List<ComplaintViewDTO> list = new List<ComplaintViewDTO>();
      
            foreach (var id in complaintsIds)
            {
                var result = await _getComplaintByIdHandler.Handle
                    (new GetComplaintByIdQuery(id), cancellationToken);
                list.Add(result.Value);


            }



            return Result<List<ComplaintViewDTO>>.Success(list);
        }
    }
}
