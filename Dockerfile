# Use the official .NET runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Install curl for healthchecks and create a non-root user for security
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* && \
    adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["pipeops-asp-dotnet-core.csproj", "./"]
RUN dotnet restore "pipeops-asp-dotnet-core.csproj"
COPY . .
RUN dotnet build "pipeops-asp-dotnet-core.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "pipeops-asp-dotnet-core.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage: copy the published app to the runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "pipeops-asp-dotnet-core.dll"]
