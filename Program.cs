var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Welcome to Pipeops ASP.NET Core Sample App!");

app.Run();
