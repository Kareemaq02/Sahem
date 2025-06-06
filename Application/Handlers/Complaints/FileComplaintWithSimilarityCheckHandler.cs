﻿using Application.Commands;
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
using System.Globalization;

namespace Application.Handlers.Complaints
{
    public class FileComplaintWithSimilarityCheckHandler
        : IRequestHandler<InsertComplaintWithSimilarityCheckCommand, Result<InsertComplaintDTO>>
    {
        private readonly DataContext _context;
        private readonly IConfiguration _configuration;
        public readonly UserManager<ApplicationUser> _userManager;
        private readonly AddComplaintStatusChangeTransactionHandler _transactionHandler;

        public FileComplaintWithSimilarityCheckHandler(
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
            InsertComplaintWithSimilarityCheckCommand request,
            CancellationToken cancellationToken
        )
        {
            var complaintDTO = request.ComplaintDTO;
            var lstMedia = complaintDTO.lstMedia;
            var userId = await _context.Users
                .Where(u => u.UserName == complaintDTO.strUserName)
                .Select(u => u.Id)
                .SingleOrDefaultAsync();

            var similarLatLng = new LatLng
            {
                decLat = request.ComplaintDTO.lstMedia.ElementAt(0).decLat,
                decLng = request.ComplaintDTO.lstMedia.ElementAt(0).decLng,
            };

            var query =
                from c in _context.Complaints
                join ca in _context.ComplaintAttachments on c.intId equals ca.intComplaintId
                let queryComplaintLatLng = new LatLng { decLat = ca.decLat, decLng = ca.decLng }
                where
                    (
                        c.intTypeId == request.ComplaintDTO.intTypeId
                            && c.intPrivacyId
                                == (int)ComplaintsConstant.complaintPrivacy.privacyPublic
                            && (c.intStatusId == (int)ComplaintsConstant.complaintStatus.Scheduled
                        || c.intStatusId == (int)ComplaintsConstant.complaintStatus.inProgress
                        || c.intStatusId == (int)ComplaintsConstant.complaintStatus.waitingEvaluation
                        || c.intStatusId == (int)ComplaintsConstant.complaintStatus.pending)
                    )
                select new
                {
                    Complaint = c,
                    LatLng = queryComplaintLatLng,
                    Attachments = ca
                };

            var closestComplaint = query
                .AsEnumerable()
                .Where(
                    item =>
                        EuclideanDistanceHelper.EuclideanDistance(similarLatLng, item.LatLng)
                        <= EuclideanDistanceHelper.radiusInDegrees
                )
                .OrderBy(
                    item => EuclideanDistanceHelper.EuclideanDistance(similarLatLng, item.LatLng)
                )
                .Select(
                    item =>
                        new
                        {
                            item.Complaint,
                            item.Attachments,
                            Distance = EuclideanDistanceHelper.EuclideanDistance(
                                similarLatLng,
                                item.LatLng
                            )
                        }
                )
                .FirstOrDefault();

            if (closestComplaint == null)
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    // Get Region based on lat and lng
                    RegionNames region = GetRegionName
                           .getRegionNameByLatLng(similarLatLng.decLat, similarLatLng.decLng);

                   

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
                        intRegionId = existingRegionId
                    };
                    var complaintEntity = await _context.Complaints.AddAsync(complaint);
                    await _context.SaveChangesAsync(cancellationToken);
                    Console.WriteLine(DateTime.UtcNow.ToString("dd dddd , MMMM, yyyy", new CultureInfo("ar-AE")));
                    complaintDTO.intId = complaintEntity.Entity.intId;

                    if (lstMedia.Count == 0)
                    {
                        await transaction.RollbackAsync();
                        return Result<InsertComplaintDTO>.Failure("No file was Uploaded.");
                    }

                    double radius = 0.0002245;
                    var targetLatLng = new LatLng
                    {
                        decLat = request.ComplaintDTO.lstMedia.ElementAt(0).decLat,
                        decLng = request.ComplaintDTO.lstMedia.ElementAt(0).decLng,
                    };

                    var query2 =
                        from c in _context.Complaints
                        join ca in _context.ComplaintAttachments on c.intId equals ca.intComplaintId
                        let complaintLatLng = new LatLng { decLat = ca.decLat, decLng = ca.decLng }
                        let distance = Math.Sqrt(
                            Math.Pow((double)(targetLatLng.decLat - complaintLatLng.decLat), 2)
                                + Math.Pow(
                                    (double)(targetLatLng.decLng - complaintLatLng.decLng),
                                    2
                                )
                        )
                        where
                            (
                                distance <= radius
                                && c.dtmDateCreated > DateTime.Now.AddHours(-24)
                                && c.intUserID == userId
                                && c.intTypeId == request.ComplaintDTO.intTypeId
                            )
                        select c;

                    var similarComplaintsCount = await query2.CountAsync();

                    if (similarComplaintsCount > 2)
                    {
                        await transaction.RollbackAsync();
                        return Result<InsertComplaintDTO>.Failure(
                            "You have already submitted 3 complaints"
                                + " in the same area within the last 24 hours"
                        );
                    }
                    var complaintAttachments = new List<ComplaintAttachment>();
                    foreach (var media in lstMedia)
                    {
                        if (media == null || media.fileMedia == null)
                        {
                            await transaction.RollbackAsync();
                            return Result<InsertComplaintDTO>.Failure(
                                "File was not received (null)."
                            );
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

                    await _transactionHandler.Handle(
                        new AddComplaintStatusChangeTransactionCommand(
                            complaint.intId,
                            (int)ComplaintsConstant.complaintStatus.pending
                        ),
                        cancellationToken
                    );

                    await _context.SaveChangesAsync(cancellationToken);
                    await transaction.CommitAsync();
                }
                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    return Result<InsertComplaintDTO>.Failure("Unknown Error" + e.ToString());
                }

                return Result<InsertComplaintDTO>.Success(complaintDTO);
            }
            else
            {
                var similarComplaintDTO = new InsertComplaintDTO
                {
                    intId = closestComplaint.Complaint.intId,
                    intTypeId = closestComplaint.Complaint.intTypeId,
                    intPrivacyId = closestComplaint.Complaint.intPrivacyId,
                    blnHasSimilar = true,
                    similarComplaintLstMedia =
                        closestComplaint.Attachments != null
                            ? closestComplaint.Complaint.Attachments
                                .Select(
                                    ca =>
                                        new Media
                                        {
                                            Data = File.Exists(ca.strMediaRef)
                                                ? Convert.ToBase64String(
                                                    File.ReadAllBytes(ca.strMediaRef)
                                                )
                                                : string.Empty,
                                            IsVideo = ca.blnIsVideo
                                        }
                                )
                                .ToList()
                            : null,
                    strComment = closestComplaint.Complaint.strComment,
                    intRegionId = closestComplaint.Complaint.intRegionId
                };

                return Result<InsertComplaintDTO>.Success(similarComplaintDTO);
            }
        }
    }
}
