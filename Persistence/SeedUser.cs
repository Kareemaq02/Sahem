using Domain.DataModels.User;
using Microsoft.AspNetCore.Identity;

namespace Persistence
{
    public class SeedUser
    {
        public static async Task SeedUsers(
            DataContext context,
            UserManager<ApplicationUser> userManager,
            int type,
            int i
        )
        {
            Random random = new Random();

            string[] arabicFirstNames =
            {
                "Ali",
                "Amira",
                "Nour",
                "Mohammed",
                "Rima",
                "Zeinab",
                "Hussein",
                "Fatima",
                "Omar",
                "Maryam"
            };
            string[] arabicLastNames =
            {
                "AlSaadi",
                "AlMahdi",
                "AlAlawi",
                "AlHusseini",
                "AlObaidi",
                "AlMuradi",
                "AlMousawi",
                "AlSadr",
                "AlSharifi",
                "AlQazwini"
            };
            Dictionary<string, string> firstNameMapping = new Dictionary<string, string>
            {
                { "Ali", "علي" },
                { "Amira", "أميرة" },
                { "Nour", "نور" },
                { "Mohammed", "محمد" },
                { "Rima", "ريما" },
                { "Zeinab", "زينب" },
                { "Hussein", "حسين" },
                { "Fatima", "فاطمة" },
                { "Omar", "عمر" },
                { "Maryam", "مريم" },

            };
            Dictionary<string, string> lastNameMapping = new Dictionary<string, string>
            {
                { "AlSaadi", "السعدي" },
                { "AlMahdi", "المهدي" },
                { "AlAlawi", "العلوي" },
                { "AlHusseini", "الحسيني" },
                { "AlObaidi", "العبيدي" },
                { "AlMuradi", "المرادي" },
                { "AlMousawi", "الموسوي" },
                { "AlSadr", "الصدر" },
                { "AlSharifi", "الشريفي" },
                { "AlQazwini", "القزويني" },
            };

            var randomEnglishFirstName = arabicFirstNames[random.Next(0, arabicFirstNames.Length)];
            var randomArabicFirstName = firstNameMapping[randomEnglishFirstName];

            var randomEnglishLastName = arabicLastNames[random.Next(0, arabicLastNames.Length)];
            var randomArabicLastName = lastNameMapping[randomEnglishLastName];
            var info = await context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = randomEnglishFirstName,
                    strLastName = randomEnglishLastName,
                    strFirstNameAr = randomArabicFirstName,
                    strLastNameAr = randomArabicLastName,
                    strPhoneNumber = GenaratePhoneNumber(context),
                    strNationalId = GenaratNationalId(context),
                    strNationalIdNumber = GenarateNationalIdNumber(context)
                }
            );
            await context.SaveChangesAsync();

            var user = new ApplicationUser
            {
                UserName = info.Entity.strFirstName + "." + info.Entity.strLastName + i.ToString(),
                PhoneNumberConfirmed = true,
                blnIsVerified = false,
                blnIsActive = false,
                blnIsBlacklisted = false,
                intUserInfoId = info.Entity.intId,
                intUserTypeId = type,
            };

            await userManager.CreateAsync(user, "Pass@123");
        }

        private static string GenaratePhoneNumber(DataContext context)
        {
            Random random = new Random();

            bool isUnique = false;
            string phoneNumber = "";
            while (!isUnique)
            {
                phoneNumber =
                    "07" + random.Next(7, 9).ToString() + random.Next(1000000, 9999999).ToString();
                if (!context.UserInfos.Any(q => q.strPhoneNumber == phoneNumber))
                {
                    isUnique = true;
                    return phoneNumber;
                }
            }

            return null;
        }

        private static string GenarateNationalIdNumber(DataContext context)
        {
            Random random = new Random();

            bool isUnique = false;
            string nationalIdNumber = "";
            while (!isUnique)
            {
                nationalIdNumber =
                    (char)('A' + random.Next(0, 26))
                    + (char)('A' + random.Next(0, 26))
                    + (char)('A' + random.Next(0, 26))
                    + random.Next(10000, 99999).ToString();
                if (!context.UserInfos.Any(q => q.strNationalIdNumber == nationalIdNumber))
                {
                    isUnique = true;
                    return nationalIdNumber;
                }
            }

            return null;
        }

        private static string GenaratNationalId(DataContext context)
        {
            Random random = new Random();

            bool isUnique = false;
            string nationalId = "";
            while (!isUnique)
            {
                nationalId =
                    random.Next(10000, 99999).ToString() + random.Next(10000, 99999).ToString();
                if (!context.UserInfos.Any(q => q.strNationalId == nationalId))
                {
                    isUnique = true;
                    return nationalId;
                }
            }

            return null;
        }
    }
}
