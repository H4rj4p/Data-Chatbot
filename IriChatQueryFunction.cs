using System.Net;
using System.Text.Json;
using System.Text.RegularExpressions;
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
        var (question, history, confirmedSurname, confirmedCustomerId) = ChatHistoryParser.ParseRequest(body);

        if (string.IsNullOrWhiteSpace(question))
        {
            response.StatusCode = HttpStatusCode.BadRequest;
            await response.WriteAsJsonAsync(new { error = "Send JSON like { \"message\": \"your question\", \"history\": [] }." });
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
            string? customersTable = await _schemaProvider.GetCustomersTableNameAsync();
            if (string.IsNullOrWhiteSpace(customersTable))
            {
                var tables = await _schemaProvider.ListTablesAsync();
                await response.WriteAsJsonAsync(new
                {
                    answer = "I can't find a Customers table in bank_data. Create/import your data first, then try again.",
                    error = tables.Count == 0
                        ? "No tables found in bank_data."
                        : $"Tables found: {string.Join(", ", tables)}"
                });
                return response;
            }

            string sqlQuery = await GenerateSqlAsync(question, history, customersTable, confirmedSurname, confirmedCustomerId);
            sqlQuery = SqlSafety.CleanSql(sqlQuery, customersTable);

            if (sqlQuery.Equals("NA", StringComparison.OrdinalIgnoreCase))
            {
                await response.WriteAsJsonAsync(new
                {
                    query = "NA",
                    answer = "I couldn't map that question to your bank_data tables. Open /api/GetDatabaseSchema to see table and column names, then ask using those names — for example: \"What is the credit score for customers named Hill?\"",
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
            var candidates = SurnameDisambiguation.GetCandidates(results);

            if (SurnameDisambiguation.ShouldConfirm(candidates, question, confirmedCustomerId))
            {
                await response.WriteAsJsonAsync(new
                {
                    query = sqlQuery,
                    answer = $"I found {candidates.Count} matching customers. Which one did you mean?",
                    needs_confirmation = true,
                    candidates = candidates.Select(c => new
                    {
                        customer_id = c.CustomerId,
                        surname = c.Surname
                    }),
                    data = results,
                    chart_type = "table"
                });
                return response;
            }

            var (answer, chartType) = await GenerateAnswerAsync(
                question, history, results, confirmedSurname, confirmedCustomerId);
            chartType = ChartRecommender.Recommend(results, chartType, question);

            await response.WriteAsJsonAsync(new
            {
                query = sqlQuery,
                answer,
                data = results,
                chart_type = chartType
            });
        }
        catch (MySqlException ex)
        {
            await response.WriteAsJsonAsync(new
            {
                answer = "I couldn't run the database query. The table or column name may be wrong for your bank_data database.",
                error = ex.Message
            });
        }
        catch (Exception ex)
        {
            response.StatusCode = HttpStatusCode.OK;
            await response.WriteAsJsonAsync(new
            {
                error = ex.Message,
                answer = ex.Message.Contains("OpenAI", StringComparison.OrdinalIgnoreCase)
                    ? "ChatGPT request failed. Check your API key, billing, and restart the app after updating local.settings.json."
                    : $"Something went wrong: {ex.Message}"
            });
        }

        return response;
    }

    private static string ExtractSqlQuery(string raw)
    {
        raw = raw
            .Replace("```json", "", StringComparison.OrdinalIgnoreCase)
            .Replace("```sql", "", StringComparison.OrdinalIgnoreCase)
            .Replace("```", "")
            .Trim();

        try
        {
            using var doc = JsonDocument.Parse(raw);
            foreach (var propertyName in new[] { "query", "Query", "sql", "SQL" })
            {
                if (doc.RootElement.TryGetProperty(propertyName, out var queryProp))
                    return queryProp.GetString() ?? "NA";
            }
        }
        catch
        {
            Console.WriteLine("[WARN] Could not parse SQL JSON response.");
        }

        var sqlMatch = Regex.Match(
            raw,
            @"\bSELECT\b[\s\S]+",
            RegexOptions.IgnoreCase);

        if (sqlMatch.Success)
            return sqlMatch.Value.Trim().TrimEnd(';');

        return raw;
    }

    private async Task<string> GenerateSqlAsync(
        string question,
        List<ChatMessage> history,
        string customersTable,
        string? confirmedSurname,
        string? confirmedCustomerId)
    {
        string schemaText = await _schemaProvider.GetSchemaTextAsync();
        string instructionsText = SchemaProvider.LoadTextFile("instructions.txt");
        string samplesText = SchemaProvider.LoadTextFile("sample_queries.txt");
        string userPrompt = MultiPartQuestions.EnhanceForSql(
            ChatHistoryParser.FormatForPrompt(question, history, confirmedSurname, confirmedCustomerId));

        string systemPrompt =
            $"{instructionsText}\n\n" +
            $"The actual MySQL table name is `{customersTable}`. Always use that exact table name in SQL.\n\n" +
            $"Database schema:\n```sql\n{schemaText}\n```\n\n" +
            $"Example queries:\n```sql\n{samplesText}\n```\n\n" +
            "Use conversation history for follow-ups. Person names go in Surname. Location questions use Geography. " +
            "Multi-part messages must produce ONE SELECT that answers every part. Never use semicolons.";

        string raw = await _openAi.GetCompletionAsync(systemPrompt, userPrompt);
        return ExtractSqlQuery(raw);
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
        List<ChatMessage> history,
        List<Dictionary<string, object?>> data,
        string? confirmedSurname,
        string? confirmedCustomerId)
    {
        string jsonData = JsonSerializer.Serialize(data);
        string userPrompt = MultiPartQuestions.EnhanceForAnswer(
            ChatHistoryParser.FormatForPrompt(question, history, confirmedSurname, confirmedCustomerId));
        string systemPrompt =
            "You are the IRI Chatbot. Give a very short 1-2 line factual summary only. " +
            "Be terse and direct — like a headline, not a conversation. " +
            "No greetings, filler, or phrases like 'based on the data' or 'I found that'. " +
            "Examples: '4 customers.' '4 customers above 40 with tenure 2.' 'Hargrave is 42 years old.' " +
            "'10,000 customers; 4,559 male.' 'Average salary is 100,214.' " +
            "For multi-part questions, fit all parts into 1-2 short lines separated by semicolons. " +
            "Use conversation history for follow-ups (he/she/they). " +
            "Never output JSON, code blocks, or raw data in the answer text. " +
            "Use only the provided data. If no rows, say 'No matching data.' " +
            "Set chart_type to table unless the user explicitly asked for a graph/chart/plot/visual. " +
            "If they asked for a chart, pick bar, pie, or line based on the data. " +
            "Respond ONLY in JSON with keys 'answer' and 'chart_type'. " +
            "chart_type must be one of: bar, line, pie, table.";

        string raw = await _openAi.GetCompletionAsync(
            systemPrompt,
            $"{userPrompt}\nData: {jsonData}");

        try
        {
            using var doc = JsonDocument.Parse(raw);
            string answer = doc.RootElement.GetProperty("answer").GetString() ?? "";
            string chartType = doc.RootElement.GetProperty("chart_type").GetString() ?? "table";
            return (answer, chartType);
        }
        catch
        {
            return (ExtractAnswerFromRaw(raw), "table");
        }
    }

    private static string ExtractAnswerFromRaw(string raw)
    {
        raw = raw
            .Replace("```json", "", StringComparison.OrdinalIgnoreCase)
            .Replace("```", "")
            .Trim();

        try
        {
            using var doc = JsonDocument.Parse(raw);
            if (doc.RootElement.TryGetProperty("answer", out var answerProp))
                return answerProp.GetString() ?? "Here's what I found.";
        }
        catch
        {
        }

        var match = Regex.Match(raw, @"""answer""\s*:\s*""((?:\\.|[^""\\])*)""");
        if (match.Success)
        {
            try
            {
                return JsonSerializer.Deserialize<string>($"\"{match.Groups[1].Value}\"") ?? match.Groups[1].Value;
            }
            catch
            {
                return match.Groups[1].Value;
            }
        }

        if (raw.StartsWith('{') || raw.StartsWith('['))
            return "Here's what I found in the data above.";

        return raw;
    }
}
