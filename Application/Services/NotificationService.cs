using Persistence;
using System.Text;
using System.Text.Json;
using System.Net.Http.Headers;
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

        public void SendNotifications(List<int> userIds, string strHeaderAr, string strBodyAr)
        {
            foreach (int userId in userIds)
            {
                string registrationToken = _context.NotificationTokens
                    .Where(nt => nt.intUserId == userId)
                    .Select(nt => nt.strToken)
                    .FirstOrDefault();

                if (!string.IsNullOrEmpty(registrationToken))
                {
                    var payload = new
                    {
                        message = new
                        {
                            token = registrationToken,
                            notification = new { title = strHeaderAr, body = strBodyAr }
                        }
                    };

                    var jsonPayload = JsonSerializer.Serialize(payload);

                    // Fire-and-forget task to send the notification
                    _ = SendNotificationAsync(jsonPayload);


                }
            }
        }

        public async Task SendNotificationAsync(string jsonPayload)
        {
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

                // Send the notification asynchronously without awaiting the response
                var _ = await client.PostAsync(fcmUrl, content);
            }
        }
    }
}
