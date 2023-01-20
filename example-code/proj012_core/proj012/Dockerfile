#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["proj012.csproj", "proj012/"]
RUN dotnet restore "proj012/proj012.csproj"
WORKDIR "/src/proj012"
COPY . .

RUN dotnet build "proj012.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "proj012.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "proj012.dll"]