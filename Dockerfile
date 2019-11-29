FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY PaperclipPerfector.csproj .
RUN dotnet restore "PaperclipPerfector.csproj"
COPY . .
RUN dotnet build "PaperclipPerfector.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PaperclipPerfector.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
VOLUME /var/data
ENV PPDATAMOUNT=/var/data
ENTRYPOINT ["dotnet", "PaperclipPerfector.dll"]