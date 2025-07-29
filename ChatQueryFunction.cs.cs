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

        // Step 4: Generate human-readable answer
        string naturalResponse = await GenerateAnswer(userMessage, results);

        // Respond
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new
        {
            query = sqlQuery,
            answer = naturalResponse,
            data = results
        });

        return response;
    }

    // === Load Schema from file ===
    private string LoadSchema()
    {
        string schemaPath = Path.Combine(AppContext.BaseDirectory, "schema.sql");
        if (!File.Exists(schemaPath))
        {
            Console.WriteLine($"[ERROR] Schema file not found at {schemaPath}");
            return string.Empty;
        }
        return File.ReadAllText(schemaPath);
    }

    // === Generate SQL from user question ===
    private async Task<string> GenerateSqlFromQuestion(string question)
    {
        var client = new OpenAIClient(new Uri(_openAIEndpoint), new AzureKeyCredential(_openAIKey));
        string schemaText = LoadSchema(); // Load schema into system prompt

        var chatOptions = new ChatCompletionsOptions
        {
            Temperature = 0,
            DeploymentName = _deploymentName,
            Messages =
            {
                new ChatRequestSystemMessage(
                    $"You are an AI that converts user questions into valid T-SQL queries for the BlueBird database. " +
                    $"Use ONLY the exact table and column names from this schema:\n\n{schemaText}\n\n" +
                    $"Rules:\n" +
                    $"- Do not pluralize table names.\n" +
                    $"- Do not use backticks or MySQL syntax.\n" +
                    $"- Use schema prefix 'BlueBird.' for all tables.\n"
                ),
                new ChatRequestUserMessage(question)
            }
        };

        var response = await client.GetChatCompletionsAsync(chatOptions);

        var sql = response.Value.Choices[0].Message.Content ?? "";
        return sql.Trim();
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
        string[] tables = { "Account", "SalesRep", "Territory", "Event", "Organization" };

        foreach (var table in tables)
        {
            // Add prefix only if not already present
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

    // === Summarize data in natural language ===
    private async Task<string> GenerateAnswer(string question, List<Dictionary<string, object>> data)
    {
        var client = new OpenAIClient(new Uri(_openAIEndpoint), new AzureKeyCredential(_openAIKey));
        string jsonData = JsonSerializer.Serialize(data);

        var chatOptions = new ChatCompletionsOptions
        {
            Temperature = 0,
            DeploymentName = _deploymentName,
            Messages =
            {
                new ChatRequestSystemMessage("You summarize SQL query results into plain English for the user."),
                new ChatRequestUserMessage($"Question: {question}\nData: {jsonData}")
            }
        };

        var response = await client.GetChatCompletionsAsync(chatOptions);
        return response.Value.Choices[0].Message.Content.Trim();
    }
}
