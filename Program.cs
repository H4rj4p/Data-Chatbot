using System.Text.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

LoadLocalSettings();

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

builder.Services
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights();

builder.Build().Run();

static void LoadLocalSettings()
{
    string baseDir = AppContext.BaseDirectory;
    string[] paths =
    {
        Path.Combine(baseDir, "local.settings.json"),
        Path.Combine(Directory.GetCurrentDirectory(), "local.settings.json"),
        Path.Combine(baseDir, "..", "..", "..", "local.settings.json")
    };

    string? settingsPath = paths.FirstOrDefault(File.Exists);
    if (settingsPath == null)
        return;

    using var doc = JsonDocument.Parse(File.ReadAllText(settingsPath));
    if (!doc.RootElement.TryGetProperty("Values", out var values))
        return;

    foreach (var item in values.EnumerateObject())
    {
        string? value = item.Value.GetString();
        if (string.IsNullOrEmpty(value))
            continue;

        Environment.SetEnvironmentVariable(item.Name, value);
    }
}
