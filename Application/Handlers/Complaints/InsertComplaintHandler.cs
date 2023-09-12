using Application.Commands;
using Application.Core;
using Domain.ClientDTOs.Complaint;
using Domain.DataModels.Complaints;
using Domain.DataModels.Intersections;
using Domain.DataModels.User;
using Domain.Helpers;
using Domain.Resources;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Persistence;
using System.Data.Entity.Infrastructure;

namespace Application.Handlers.Complaints
{
    public class InsertComplaintHandler
        : IRequestHandler<InsertComplaintCommand, Result<InsertComplaintDTO>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;
        public readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

        public InsertComplaintHandler(
            DataContext context,
            IConfiguration configuration,
            UserManager<ApplicationUser> userManager,
            AddComplaintStatusChangeTransactionHandler transactionHandler
        )
        {
            _context = context;
            _configuration = configuration;
            _userManager = userManager;
            _transactionHandler = transactionHandler;
        }

        public async Task<Result<InsertComplaintDTO>> Handle(
            InsertComplaintCommand request,
            CancellationToken cancellationToken
        )
        {
            var complaintDTO = request.ComplaintDTO;
            var lstMedia = complaintDTO.lstMedia;
            var userId = await _context.Users
                .Where(u => u.UserName == complaintDTO.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            using var transaction = await _context.Database.BeginTransactionAsync(
                cancellationToken
            );
            try
            {
                // Get Region based on lat and lng
                RegionNames region = GetRegionName
                       .getRegionNameByLatLng(request.ComplaintDTO.lstMedia.ElementAt(0).decLat
                       , request.ComplaintDTO.lstMedia.ElementAt(0).decLng);



                var existingRegionId = await _context.Regions
                    .Where(q => q.strNameEn == region.strRegionEn)
                    .Select(q => q.intId).SingleOrDefaultAsync();

                complaintDTO.intRegionId = existingRegionId;


                if (existingRegionId == 0)
                {
                    var regionEntity = await _context.Regions.AddAsync(new Region
                    {
                        strNameAr = region.strRegionAr,
                        strNameEn = region.strRegionEn,
                        strShapePath = "C:\\Fake\\Path\\Files\\test.shp"
                    });

                    await _context.SaveChangesAsync();
                    existingRegionId = regionEntity.Entity.intId;
                    complaintDTO.intRegionId = existingRegionId;
                }

                var complaint = new Complaint
                {
                    intUserID = userId,
                    intTypeId = complaintDTO.intTypeId,
                    intStatusId = 1,
                    strComment = complaintDTO?.strComment,
                    intReminder = 1,
                    intPrivacyId = complaintDTO.intPrivacyId,
                    dtmDateCreated = DateTime.UtcNow,
                    dtmDateLastReminded = DateTime.UtcNow,
                    intLastModifiedBy = userId,
                    dtmDateLastModified = DateTime.UtcNow,
                    intRegionId = existingRegionId, 
                };
                var complaintEntity = await _context.Complaints.AddAsync(complaint);
                await _context.SaveChangesAsync(cancellationToken);

                complaintDTO.intId = complaintEntity.Entity.intId;

                if (lstMedia.Count == 0)
                {
                    await transaction.RollbackAsync();
                    return Result<InsertComplaintDTO>.Failure("No file was Uploaded.");
                }
                       
                var complaintAttachments = new List<ComplaintAttachment>();
                foreach (var media in lstMedia)
                {
                    if (media == null || media.fileMedia == null)
                    {
                        await transaction.RollbackAsync();
                        return Result<InsertComplaintDTO>.Failure("File was not received (null).");
                    }
                    string extension = Path.GetExtension(media.fileMedia.FileName);
                    string fileName = $"{DateTime.UtcNow.Ticks}{extension}";
                    string directory = _configuration["FilesPath"];
                    string path = Path.Join(
                        DateTime.UtcNow.Year.ToString(),
                        DateTime.UtcNow.Month.ToString(),
                        DateTime.UtcNow.Day.ToString(),
                        complaintEntity.Entity.intId.ToString()
                    );
                    string filePath = Path.Join(directory, path, fileName);

                    // Create directory if it doesn't exist
                    Directory.CreateDirectory(Path.Combine(directory, path));

                    // Create file
                    using var stream = File.Create(filePath);
                    await media.fileMedia.CopyToAsync(stream, cancellationToken);

                    complaintAttachments.Add(
                        new ComplaintAttachment
                        {
                            intComplaintId = complaintEntity.Entity.intId,
                            strMediaRef = filePath,
                            decLat = media.decLat,
                            decLng = media.decLng,
                            blnIsVideo = media.blnIsVideo,
                            dtmDateCreated = DateTime.UtcNow,
                            intCreatedBy = userId
                        }
                    );
                }

                await _context.ComplaintAttachments.AddRangeAsync(complaintAttachments);
                await _context.SaveChangesAsync(cancellationToken);

                await _transactionHandler.Handle
                        (
                        new AddComplaintStatusChangeTransactionCommand
                        (
                            complaint.intId
                        ,
                            (int)ComplaintsConstant.complaintStatus.pending
                        )
                        ,
                         cancellationToken
                        );

                await _context.SaveChangesAsync(cancellationToken);
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                await transaction.RollbackAsync();
                return Result<InsertComplaintDTO>.Failure("Unknown Error" + e);
            }

            return Result<InsertComplaintDTO>.Success(complaintDTO);
        }
    }
}
