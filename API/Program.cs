using Persistence;
using API.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using Domain.DataModels.User;
using Application.Handlers.Tasks;
using Application.Handlers.Complaints;
using Application.Services;
using MediatR;
using Application.Seed;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers(opt =>
{
    var policy = new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build();
    opt.Filters.Add(new AuthorizeFilter(policy));
});

builder.Services.AddApplicationServices(builder.Configuration);
builder.Services.AddCorsService(builder.Configuration, builder.Environment);
builder.Services.AddIdentityService(builder.Configuration);
builder.Services.AddTransient<InsertTaskHandler>();
builder.Services.AddTransient<AddComplaintStatusChangeTransactionHandler>();
builder.Services.AddTransient<GetComplaintByIdHandler>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("CorsPolicy");

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

// Debug seeding
using var scope = app.Services.CreateScope();
var services = scope.ServiceProvider;

try
{
    var context = services.GetRequiredService<DataContext>();
    var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
    var mediator = services.GetRequiredService<IMediator>();

    await context.Database.MigrateAsync();
    var seed = new Seed(context, userManager, mediator, services);
    await seed.SeedData();
}
catch (Exception ex)
{
    var logger = services.GetRequiredService<ILogger<Program>>();
    logger.LogError(ex, "An error occured during seeding");
}

app.Run();
