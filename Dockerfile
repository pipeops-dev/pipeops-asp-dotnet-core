# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["pipeops-asp-dotnet-core.csproj", "./"]
RUN dotnet restore "pipeops-asp-dotnet-core.csproj"

# Copy everything else and build
COPY . .
RUN dotnet publish "pipeops-asp-dotnet-core.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Copy published files from build stage
COPY --from=build /app/publish .

# Set the entry point
ENTRYPOINT ["dotnet", "pipeops-asp-dotnet-core.dll"]
