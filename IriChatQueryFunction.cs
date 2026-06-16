using System.Net;
using System.Text.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using MySqlConnector;

public class IriChatQueryFunction
{
    private const int MaxRows = 100;

    private readonly string? _sqlConnectionString;
    private readonly OpenAiClient _openAi;
    private readonly SchemaProvider _schemaProvider;

    public IriChatQueryFunction()
    {
        _sqlConnectionString = AppConfig.GetSqlConnectionString();
        _openAi = new OpenAiClient(
            Environment.GetEnvironmentVariable("OpenAIApiKey"),
            Environment.GetEnvironmentVariable("OpenAIModel"));
        _schemaProvider = new SchemaProvider(_sqlConnectionString);
    }

    [Function("AskQuestion")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req)
    {
        var response = req.CreateResponse(HttpStatusCode.OK);
        HttpCors.Apply(response);

        var body = await new StreamReader(req.Body).ReadToEndAsync();
        var data = JsonSerializer.Deserialize<Dictionary<string, string>>(body);
        string question = data?.GetValueOrDefault("message") ?? "";

        if (string.IsNullOrWhiteSpace(question))
        {
            response.StatusCode = HttpStatusCode.BadRequest;
            await response.WriteAsJsonAsync(new { error = "Send JSON like { \"message\": \"your question\" }." });
            return response;
        }

        if (string.IsNullOrWhiteSpace(_sqlConnectionString))
        {
            response.StatusCode = HttpStatusCode.BadRequest;
            await response.WriteAsJsonAsync(new { error = "SqlConnectionString is not configured." });
            return response;
        }

        if (string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("OpenAIApiKey")))
        {
            await response.WriteAsJsonAsync(new
            {
                answer = "Chat is not set up yet. Add your OpenAI API key to local.settings.json when you're ready."
            });
            return response;
        }

        try
        {
            string sqlQuery = await GenerateSqlAsync(question);
            sqlQuery = SqlSafety.CleanSql(sqlQuery);

            if (sqlQuery.Equals("NA", StringComparison.OrdinalIgnoreCase))
            {
                await response.WriteAsJsonAsync(new
                {
                    query = "NA",
                    answer = "I could not turn that question into a safe SQL query.",
                    data = Array.Empty<object>(),
                    chart_type = "table"
                });
                return response;
            }

            if (!SqlSafety.TryValidateSelectQuery(sqlQuery, out string validationError))
            {
                await response.WriteAsJsonAsync(new
                {
                    query = sqlQuery,
                    answer = $"Query blocked for safety: {validationError}",
                    data = Array.Empty<object>(),
                    chart_type = "table"
                });
                return response;
            }

            var results = await ExecuteSqlAsync(sqlQuery);
            var (answer, chartType) = await GenerateAnswerAsync(question, results);

            await response.WriteAsJsonAsync(new
            {
                query = sqlQuery,
                answer,
                data = results,
                chart_type = chartType
            });
        }
        catch (Exception ex)
        {
            response.StatusCode = HttpStatusCode.OK;
            await response.WriteAsJsonAsync(new
            {
                error = ex.Message,
                answer = "Something went wrong while answering your question."
            });
        }

        return response;
    }

    private async Task<string> GenerateSqlAsync(string question)
    {
        string schemaText = await _schemaProvider.GetSchemaTextAsync();
        string instructionsText = SchemaProvider.LoadTextFile("instructions.txt");
        string samplesText = SchemaProvider.LoadTextFile("sample_queries.txt");

        string systemPrompt =
            $"{instructionsText}\n\n" +
            $"Database schema:\n```sql\n{schemaText}\n```\n\n" +
            $"Example queries:\n```sql\n{samplesText}\n```";

        string raw = await _openAi.GetCompletionAsync(systemPrompt, question);
        raw = raw.Replace("```json", "", StringComparison.OrdinalIgnoreCase)
                 .Replace("```", "")
                 .Trim();

        try
        {
            using var doc = JsonDocument.Parse(raw);
            if (doc.RootElement.TryGetProperty("query", out var queryProp))
                return queryProp.GetString() ?? "NA";
        }
        catch
        {
            Console.WriteLine("[WARN] Could not parse SQL JSON response.");
        }

        return raw;
    }

    private async Task<List<Dictionary<string, object?>>> ExecuteSqlAsync(string sqlQuery)
    {
        var results = new List<Dictionary<string, object?>>();

        await using var connection = new MySqlConnection(_sqlConnectionString);
        await connection.OpenAsync();

        await using var command = new MySqlCommand(sqlQuery, connection);
        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync() && results.Count < MaxRows)
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
                row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
            results.Add(row);
        }

        return results;
    }

    private async Task<(string answer, string chartType)> GenerateAnswerAsync(
        string question,
        List<Dictionary<string, object?>> data)
    {
        string jsonData = JsonSerializer.Serialize(data);
        string systemPrompt =
            "You are the IRI Chatbot. Answer the user's question in clear, friendly, conversational English. " +
            "Write like ChatGPT speaking to a colleague: complete sentences, no jargon about SQL or JSON. " +
            "Use only the provided data. If there are no rows, say you couldn't find matching data. " +
            "Respond ONLY in JSON with keys 'answer' and 'chart_type'. " +
            "chart_type must be one of: bar, line, pie, table.";

        string raw = await _openAi.GetCompletionAsync(
            systemPrompt,
            $"Question: {question}\nData: {jsonData}");

        try
        {
            using var doc = JsonDocument.Parse(raw);
            string answer = doc.RootElement.GetProperty("answer").GetString() ?? "";
            string chartType = doc.RootElement.GetProperty("chart_type").GetString() ?? "table";
            return (answer, chartType);
        }
        catch
        {
            return (raw, "table");
        }
    }
}
