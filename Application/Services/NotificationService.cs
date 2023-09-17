using Persistence;
using System.Text;
using System.Text.Json;
using System.Net.Http.Headers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Google.Apis.Auth.OAuth2;

namespace Application.Services
{
    public class NotificationService
    {
        private readonly IConfiguration _configuration;
        private readonly DataContext _context;
        private readonly string _bearertoken;
        private readonly string fcmUrl;

        public NotificationService(IConfiguration configuration, DataContext context)
        {
            string fileName = "TempNotificationService.json";
            string fullPath = Path.Combine(
                AppDomain.CurrentDomain.BaseDirectory,
                "Services",
                fileName
            );

            string scopes = "https://www.googleapis.com/auth/firebase.messaging";
            using (var stream = new FileStream(fullPath, FileMode.Open, FileAccess.Read))
            {
                _bearertoken = GoogleCredential
                    .FromStream(stream)
                    .CreateScoped(scopes)
                    .UnderlyingCredential.GetAccessTokenForRequestAsync()
                    .Result;
            }

            _configuration = configuration;
            _context = context;
            fcmUrl = _configuration["NotificationsAPI"];
        }

        public async Task<HttpResponseMessage> SendNotification(int userId, string strHeaderAr, string strBodyAr)
        {
            string registrationToken = await _context.NotificationTokens
                .Where(nt => nt.intUserId == userId)
                .Select(nt => nt.strToken)
                .FirstOrDefaultAsync();

            var payload = new
            {
                message = new
                {
                    token = registrationToken,
                    notification = new
                    {
                        title = strHeaderAr,
                        body = strBodyAr
                    }
                }
            };

            var jsonPayload = JsonSerializer.Serialize(payload);

            using (var client = new HttpClient(new HttpClientHandler()))
            {
                client.BaseAddress = new Uri(fcmUrl);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json")
                );
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                    "Bearer",
                    _bearertoken
                );

                var content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");
                content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
                var response = await client.PostAsync(fcmUrl, content);

                return response;
            }
        }
    }
}
