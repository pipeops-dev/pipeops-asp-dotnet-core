var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Welcome to Pipeops ASP.NET Core Sample App! <a href='https://pipeops.io'>Pipeops Home</a>");

app.Run();
