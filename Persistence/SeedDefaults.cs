using Domain.DataModels.Complaints;
using Domain.DataModels.Tasks;
using Domain.DataModels.User;
using Domain.Resources;
using Microsoft.AspNetCore.Identity;

namespace Persistence
{
    public class SeedDefaults
    {
        public static async Task CreateDefaultUsers(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            int typeAdmin,
            int typeWorker,
            int typeLeader,
            int typeUser
        )
        {
            var infoAdmin = await context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = "admin",
                    strLastName = "admin",
                    strPhoneNumber = "0799999999",
                    strNationalId = "2000555333",
                    strNationalIdNumber = "RUX55333"
                }
            );
            var infoWorker = await context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = "worker",
                    strLastName = "worker",
                    strPhoneNumber = "0788888888",
                    strNationalId = "2000111222",
                    strNationalIdNumber = "RUX11222"
                }
            );

            var infoLeader = await context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = "leader",
                    strLastName = "leader",
                    strPhoneNumber = "0788881288",
                    strNationalId = "2099111222",
                    strNationalIdNumber = "RHU11122"
                }
            );
            var infoUser = await context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = "user",
                    strLastName = "user",
                    strPhoneNumber = "0777777777",
                    strNationalId = "2000666888",
                    strNationalIdNumber = "RUX66888"
                }
            );
            await context.SaveChangesAsync();

            // Create users AFTER awaiting info creation and types
            var userAdmin = new ApplicationUser
            {
                UserName = "admin",
                PhoneNumberConfirmed = true,
                blnIsVerified = false,
                blnIsActive = false,
                blnIsBlacklisted = false,
                intUserInfoId = infoAdmin.Entity.intId,
                intUserTypeId = typeAdmin,
            };

            var userWorker = new ApplicationUser
            {
                UserName = "worker",
                PhoneNumberConfirmed = true,
                blnIsVerified = false,
                blnIsActive = false,
                blnIsBlacklisted = false,
                intUserInfoId = infoWorker.Entity.intId,
                intUserTypeId = typeWorker,
            };

            var userLeader = new ApplicationUser
            {
                UserName = "leader",
                PhoneNumberConfirmed = true,
                blnIsVerified = false,
                blnIsActive = false,
                blnIsBlacklisted = false,
                intUserInfoId = infoLeader.Entity.intId,
                intUserTypeId = typeLeader,
            };

            var userUser = new ApplicationUser
            {
                UserName = "user",
                PhoneNumberConfirmed = true,
                blnIsVerified = false,
                blnIsActive = false,
                blnIsBlacklisted = false,
                intUserInfoId = infoUser.Entity.intId,
                intUserTypeId = typeUser,
            };

            await userManager.CreateAsync(userAdmin, "Pass@123");
            await userManager.CreateAsync(userWorker, "Pass@123");
            await userManager.CreateAsync(userLeader, "Pass@123");
            await userManager.CreateAsync(userUser, "Pass@123");
        }

        public static async Task CreateComplaintLookUpTables(DataContext context)
        {
            if (!context.ComplaintStatus.Any())
            {
                var complaintStatus = new List<ComplaintStatus>
                {
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.Pending,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.PendingAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.Rejected,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.RejectedAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.Approved,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.ApprovedAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.Scheduled,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.ScheduledAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.InProgress,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.InProgressAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.WaitingEvaluation,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.WaitingEvaluationAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.Completed,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.CompletedAr
                    },
                    new ComplaintStatus
                    {
                        strName = ConstantsDB.ComplaintStatusTypes.ReFiled,
                        strNameAr = ConstantsDB.ComplaintStatusTypes.ReFiledAr
                    }
                };
                await context.ComplaintStatus.AddRangeAsync(complaintStatus);
            }
            if (!context.ComplaintPrivacy.Any())
            {
                var complaintPrivacy = new List<ComplaintPrivacy>
                {
                    new ComplaintPrivacy
                    {
                        strNameEn = ConstantsDB.ComplaintPrivacyTypes.PrivateEn,
                        strNameAr = ConstantsDB.ComplaintPrivacyTypes.PrivateAr
                    },
                    new ComplaintPrivacy
                    {
                        strNameEn = ConstantsDB.ComplaintPrivacyTypes.PublicEN,
                        strNameAr = ConstantsDB.ComplaintPrivacyTypes.PublicAr
                    },
                    new ComplaintPrivacy
                    {
                        strNameEn = ConstantsDB.ComplaintPrivacyTypes.AnyEN,
                        strNameAr = ConstantsDB.ComplaintPrivacyTypes.AnyAr
                    },
                };
                await context.ComplaintPrivacy.AddRangeAsync(complaintPrivacy);
            }

            await context.SaveChangesAsync();

            if (!context.ComplaintTypes.Any())
            {
                var complaintTypes = new List<ComplaintType>
                {
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.WasteAccumulation.Ar,
                        ConstantsDB.ComplaintTypes.WasteAccumulation.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.ScatterWaste.Ar,
                        ConstantsDB.ComplaintTypes.ScatterWaste.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.TreePruningWaste.Ar,
                        ConstantsDB.ComplaintTypes.TreePruningWaste.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.CementSpeedBumps.Ar,
                        ConstantsDB.ComplaintTypes.CementSpeedBumps.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.ViolatingSpeedBumps.Ar,
                        ConstantsDB.ComplaintTypes.ViolatingSpeedBumps.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.WaterPools.Ar,
                        ConstantsDB.ComplaintTypes.WaterPools.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.BrokenWaterPipe.Ar,
                        ConstantsDB.ComplaintTypes.BrokenWaterPipe.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.StreetCracks.Ar,
                        ConstantsDB.ComplaintTypes.StreetCracks.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.Potholes.Ar,
                        ConstantsDB.ComplaintTypes.Potholes.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.SideSafetyRails.Ar,
                        ConstantsDB.ComplaintTypes.SideSafetyRails.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.MissingManholes.Ar,
                        ConstantsDB.ComplaintTypes.MissingManholes.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.LowerManholes.Ar,
                        ConstantsDB.ComplaintTypes.LowerManholes.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.HigherManholes.Ar,
                        ConstantsDB.ComplaintTypes.HigherManholes.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.IllegalSigns.Ar,
                        ConstantsDB.ComplaintTypes.IllegalSigns.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.BrokenSigns.Ar,
                        ConstantsDB.ComplaintTypes.BrokenSigns.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.BlockedSigns.Ar,
                        ConstantsDB.ComplaintTypes.BlockedSigns.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.StreetLightsOut.Ar,
                        ConstantsDB.ComplaintTypes.StreetLightsOut.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.BrokenWall.Ar,
                        ConstantsDB.ComplaintTypes.BrokenWall.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.BrokenPavement.Ar,
                        ConstantsDB.ComplaintTypes.BrokenPavement.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.Graffiti.Ar,
                        ConstantsDB.ComplaintTypes.Graffiti.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.ConstructionWaste.Ar,
                        ConstantsDB.ComplaintTypes.ConstructionWaste.En,
                        context
                    ),
                    CreateComplaintType(
                        ConstantsDB.ComplaintTypes.MaintenanceWaste.Ar,
                        ConstantsDB.ComplaintTypes.MaintenanceWaste.En,
                        context
                    ),
                };
                await context.ComplaintTypes.AddRangeAsync(complaintTypes);
            }

            await context.SaveChangesAsync();
        }

        private static ComplaintType CreateComplaintType(
            string strAr,
            string strEn,
            DataContext context
        )
        {
            return new ComplaintType
            {
                intDepartmentId = 1,
                strNameAr = strAr,
                strNameEn = strEn,
                decGrade = 1.0M,
                intPrivacyId = 3,
                intCreatedBy = 1,
                dtmDateCreated = DateTime.Now,
                intLastModifiedBy = 1,
                dtmDateLastModified = DateTime.Now,
                blnIsDeleted = false,
            };
        }

        public static async Task CreateTaskLookUpTables(DataContext context)
        {
            if (!context.TaskStatus.Any())
            {
                var taskStatus = new List<WorkTaskStatus>
                {
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.Inactive,
                        strNameAr = ConstantsDB.TaskStatusTypes.InactiveAr
                    },
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.InProgress,
                        strNameAr = ConstantsDB.TaskStatusTypes.InProgressAr
                    },
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.WaitingEvaluation,
                        strNameAr = ConstantsDB.TaskStatusTypes.WaitingEvaluationAr
                    },
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.Failed,
                        strNameAr = ConstantsDB.TaskStatusTypes.FailedAr
                    },
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.Incomplete,
                        strNameAr = ConstantsDB.TaskStatusTypes.IncompleteAr
                    },
                    new WorkTaskStatus
                    {
                        strName = ConstantsDB.TaskStatusTypes.Completed,
                        strNameAr = ConstantsDB.TaskStatusTypes.CompletedAr
                    },
                };
                await context.TaskStatus.AddRangeAsync(taskStatus);
            }

            await context.SaveChangesAsync();

            if (!context.TaskTypes.Any())
            {
                var tasksTypes = new List<WorkTaskType>
                {
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.WasteAccumulation.Ar,
                        ConstantsDB.ComplaintTypes.WasteAccumulation.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.ScatterWaste.Ar,
                        ConstantsDB.ComplaintTypes.ScatterWaste.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.TreePruningWaste.Ar,
                        ConstantsDB.ComplaintTypes.TreePruningWaste.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.CementSpeedBumps.Ar,
                        ConstantsDB.ComplaintTypes.CementSpeedBumps.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.ViolatingSpeedBumps.Ar,
                        ConstantsDB.ComplaintTypes.ViolatingSpeedBumps.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.WaterPools.Ar,
                        ConstantsDB.ComplaintTypes.WaterPools.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.BrokenWaterPipe.Ar,
                        ConstantsDB.ComplaintTypes.BrokenWaterPipe.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.StreetCracks.Ar,
                        ConstantsDB.ComplaintTypes.StreetCracks.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.Potholes.Ar,
                        ConstantsDB.ComplaintTypes.Potholes.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.SideSafetyRails.Ar,
                        ConstantsDB.ComplaintTypes.SideSafetyRails.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.MissingManholes.Ar,
                        ConstantsDB.ComplaintTypes.MissingManholes.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.LowerManholes.Ar,
                        ConstantsDB.ComplaintTypes.LowerManholes.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.HigherManholes.Ar,
                        ConstantsDB.ComplaintTypes.HigherManholes.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.IllegalSigns.Ar,
                        ConstantsDB.ComplaintTypes.IllegalSigns.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.BrokenSigns.Ar,
                        ConstantsDB.ComplaintTypes.BrokenSigns.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.BlockedSigns.Ar,
                        ConstantsDB.ComplaintTypes.BlockedSigns.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.StreetLightsOut.Ar,
                        ConstantsDB.ComplaintTypes.StreetLightsOut.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.BrokenWall.Ar,
                        ConstantsDB.ComplaintTypes.BrokenWall.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.BrokenPavement.Ar,
                        ConstantsDB.ComplaintTypes.BrokenPavement.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.Graffiti.Ar,
                        ConstantsDB.ComplaintTypes.Graffiti.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.ConstructionWaste.Ar,
                        ConstantsDB.ComplaintTypes.ConstructionWaste.En
                    ),
                    CreateTaskType(
                        ConstantsDB.ComplaintTypes.MaintenanceWaste.Ar,
                        ConstantsDB.ComplaintTypes.MaintenanceWaste.En
                    ),
                };
                await context.TaskTypes.AddRangeAsync(tasksTypes);
            }

            await context.SaveChangesAsync();
        }

        private static WorkTaskType CreateTaskType(string strAr, string strEn)
        {
            return new WorkTaskType
            {
                intDepartmentId = 1,
                strNameAr = strAr,
                strNameEn = strEn,
                intCreatedBy = 1,
                dtmDateCreated = DateTime.Now,
                intLastModifiedBy = 1,
                dtmDateLastModified = DateTime.Now,
                blnIsDeleted = false,
            };
        }
    }
}
