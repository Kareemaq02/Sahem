using API.Services;
using Application;
using Application.Services;
using Microsoft.EntityFrameworkCore;
using Persistence;

namespace API.Extensions
{
    public static class ApplicationServicesExtension
    {
        public static IServiceCollection AddApplicationServices(
            this IServiceCollection services,
            IConfiguration configuration
        )
        {
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();
            services.AddDbContext<DataContext>(
                opt => opt.UseMySQL(configuration.GetConnectionString("DefaultConnection"))
            );
            services.AddMediatR(
                cfg => cfg.RegisterServicesFromAssembly(typeof(MediatREntrypoint).Assembly)
            );
            services.AddScoped<NotificationService>();

            return services;
        }
    }
}
