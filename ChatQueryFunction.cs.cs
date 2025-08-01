using System.Net;
using System.Text.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Azure.AI.OpenAI;
using Microsoft.Data.SqlClient;
using Azure;

public class ChatQueryFunction
{
    private readonly string _openAIEndpoint;
    private readonly string _openAIKey;
    private readonly string _deploymentName;
    private readonly string _sqlConnectionString;

    public ChatQueryFunction()
    {
        _openAIEndpoint = Environment.GetEnvironmentVariable("OpenAIEndpoint");
        _openAIKey = Environment.GetEnvironmentVariable("OpenAIKey");
        _deploymentName = Environment.GetEnvironmentVariable("OpenAIDeploymentName");
        _sqlConnectionString = Environment.GetEnvironmentVariable("SqlConnectionString");
    }

    [Function("ChatQueryFunction")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData req)
    {
        // Parse incoming JSON
        var body = await new StreamReader(req.Body).ReadToEndAsync();
        var data = JsonSerializer.Deserialize<Dictionary<string, string>>(body);
        string userMessage = data?["message"] ?? "No message provided";
        Console.WriteLine($"[DEBUG] Incoming question: {userMessage}");

        // Step 1: Generate SQL
        string sqlQuery = await GenerateSqlFromQuestion(userMessage);
        Console.WriteLine($"[DEBUG] AI Generated SQL (raw): {sqlQuery}");

        // Step 2: Clean and validate SQL
        sqlQuery = CleanAndFixSql(sqlQuery);
        Console.WriteLine($"[DEBUG] Cleaned SQL: {sqlQuery}");

        // Step 3: Execute SQL
        var results = new List<Dictionary<string, object>>();
        if (!string.IsNullOrWhiteSpace(sqlQuery) &&
            !sqlQuery.StartsWith("NA", StringComparison.OrdinalIgnoreCase))
        {
            results = await ExecuteSql(sqlQuery);
        }

        // Step 4: Generate natural language answer + chart type
        var (naturalResponse, chartType) = await GenerateAnswerWithChart(userMessage, results);

        // Step 5: Extract SalesRepId from SQL or question
        string salesRepId = ExtractSalesRepId(sqlQuery, userMessage);

        // Respond
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new
        {
            query = sqlQuery,
            salesrep_id = salesRepId,
            answer = naturalResponse,
            data = results,
            chart_type = chartType
        });

        return response;
    }

    // === Helper to Load Files ===
    private string LoadFile(string fileName)
    {
        string path = Path.Combine(AppContext.BaseDirectory, fileName);
        if (!File.Exists(path))
        {
            Console.WriteLine($"[ERROR] File not found: {fileName}");
            return string.Empty;
        }
        return File.ReadAllText(path);
    }

    // === Generate SQL from user question with strict rules ===
    private async Task<string> GenerateSqlFromQuestion(string question)
    {
        var client = new OpenAIClient(new Uri(_openAIEndpoint), new AzureKeyCredential(_openAIKey));

        string schemaText = LoadFile("schema.sql");
        string instructionsText = LoadFile("instructions.txt");
        string samplesText = LoadFile("sample_queries.txt");

        string systemPrompt =
            $"{instructionsText}\n\n" +
            $"Here is the database schema:\n```sql\n{schemaText}\n```\n\n" +
            $"Here are example queries:\n```sql\n{samplesText}\n```";

        var chatOptions = new ChatCompletionsOptions
        {
            Temperature = 0,
            DeploymentName = _deploymentName,
            Messages =
            {
                new ChatRequestSystemMessage(systemPrompt),
                new ChatRequestUserMessage(question)
            }
        };

        var response = await client.GetChatCompletionsAsync(chatOptions);
        var raw = response.Value.Choices[0].Message.Content ?? "";

        // Remove code fences if present
        raw = raw.Replace("```json", "").Replace("```", "").Trim();

        // Parse JSON to extract "query" field (if JSON is returned)
        try
        {
            using var doc = JsonDocument.Parse(raw);
            if (doc.RootElement.TryGetProperty("query", out var queryProp))
            {
                return queryProp.GetString() ?? "NA";
            }
        }
        catch
        {
            Console.WriteLine("[WARN] Failed to parse JSON; falling back to raw content");
        }

        return raw.Trim();
    }

    // === Clean AI SQL (remove junk, enforce schema) ===
    private string CleanAndFixSql(string sql)
    {
        if (string.IsNullOrWhiteSpace(sql)) return "NA";

        // Remove markdown/backticks or accidental "sql" labels
        sql = sql.Replace("```sql", "").Replace("```", "").Replace("sql", "").Trim();

        // Convert plural table names to singular
        sql = sql.Replace("Accounts", "Account", StringComparison.OrdinalIgnoreCase)
                 .Replace("SalesReps", "SalesRep", StringComparison.OrdinalIgnoreCase)
                 .Replace("Territories", "Territory", StringComparison.OrdinalIgnoreCase)
                 .Replace("Events", "Event", StringComparison.OrdinalIgnoreCase)
                 .Replace("Organizations", "Organization", StringComparison.OrdinalIgnoreCase);

        // Ensure SELECT only
        if (!sql.StartsWith("SELECT", StringComparison.OrdinalIgnoreCase))
            return "NA";

        // Add BlueBird. schema prefix if missing
        sql = AddSchemaPrefix(sql);

        return sql;
    }

    // === Prefix BlueBird schema if missing (prevent duplicates) ===
    private string AddSchemaPrefix(string sql)
    {
        string[] tables = { "Account", "SalesRep", "Territory", "Event", "Organization", "AccountAddress" };
        foreach (var table in tables)
        {
            sql = System.Text.RegularExpressions.Regex.Replace(
                sql,
                $@"(?<!BlueBird\.)\b{table}\b",
                $"BlueBird.{table}",
                System.Text.RegularExpressions.RegexOptions.IgnoreCase
            );
        }
        return sql;
    }

    // === Execute SQL safely ===
    private async Task<List<Dictionary<string, object>>> ExecuteSql(string sqlQuery)
    {
        var results = new List<Dictionary<string, object>>();
        try
        {
            using (var connection = new SqlConnection(_sqlConnectionString))
            {
                await connection.OpenAsync();
                using (var command = new SqlCommand(sqlQuery, connection))
                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        var row = new Dictionary<string, object>();
                        for (int i = 0; i < reader.FieldCount; i++)
                            row[reader.GetName(i)] = reader.GetValue(i);
                        results.Add(row);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] SQL Execution Failed: {ex.Message}");
        }
        return results;
    }

    // === Extract SalesRepId from SQL or fallback to user message ===
    private string ExtractSalesRepId(string sqlQuery, string userMessage)
    {
        // Check SQL query
        var match = System.Text.RegularExpressions.Regex.Match(sqlQuery, @"SalesRepId\s*=\s*(\d+)");
        if (match.Success)
            return match.Groups[1].Value;

        // Fallback: Check user message
        match = System.Text.RegularExpressions.Regex.Match(userMessage, @"salesrepid\s*=?\s*(\d+)", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        if (match.Success)
            return match.Groups[1].Value;

        return "unknown";
    }

    // === Summarize data in natural language AND suggest chart type ===
    private async Task<(string answer, string chartType)> GenerateAnswerWithChart(string question, List<Dictionary<string, object>> data)
    {
        var client = new OpenAIClient(new Uri(_openAIEndpoint), new AzureKeyCredential(_openAIKey));
        string jsonData = JsonSerializer.Serialize(data);

        var chatOptions = new ChatCompletionsOptions
        {
            Temperature = 0,
            DeploymentName = _deploymentName,
            Messages =
            {
                new ChatRequestSystemMessage(
                    "You are an AI assistant that directly answers user questions based on the provided SQL data results. " +
                    "Always read the JSON `Data` and provide a direct, human-readable answer to the user's question. " +
                    "Do NOT describe the data; instead, infer the answer from it. If the data is empty, say no results found.\n\n" +
                    "Also recommend the best chart type based on the nature of the data:\n" +
                    "- Use 'bar' for category comparisons\n" +
                    "- Use 'line' for trends over time\n" +
                    "- Use 'pie' for proportions\n" +
                    "- Use 'table' if detailed list or single value\n\n" +
                    "Respond ONLY in JSON with keys 'answer' and 'chart_type'. Example:\n" +
                    "{ \"answer\": \"SalesRep 61475 is MAE CAVES.\", \"chart_type\": \"table\" }"
                ),
                new ChatRequestUserMessage($"Question: {question}\nData: {jsonData}")
            }
        };

        var response = await client.GetChatCompletionsAsync(chatOptions);
        string raw = response.Value.Choices[0].Message.Content.Trim();

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
