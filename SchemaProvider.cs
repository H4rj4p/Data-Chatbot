using MySqlConnector;

public class SchemaProvider
{
    private readonly string? _connectionString;

    public SchemaProvider(string? connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<string> GetSchemaTextAsync()
    {
        string fileSchema = LoadSchemaFile();
        if (!string.IsNullOrWhiteSpace(fileSchema))
            return fileSchema;

        return await LoadSchemaFromDatabaseAsync();
    }

    private static string LoadSchemaFile()
    {
        string path = Path.Combine(AppContext.BaseDirectory, "schema.sql");
        if (!File.Exists(path))
            return "";

        string content = File.ReadAllText(path).Trim();
        bool hasTableDefinition = content.Contains("CREATE TABLE", StringComparison.OrdinalIgnoreCase)
            || content.Contains("TABLE ", StringComparison.OrdinalIgnoreCase);

        return hasTableDefinition ? content : "";
    }

    private async Task<string> LoadSchemaFromDatabaseAsync()
    {
        if (string.IsNullOrWhiteSpace(_connectionString))
            return "-- No schema file and SqlConnectionString is not configured.";

        const string sql = """
            SELECT
                c.TABLE_SCHEMA,
                c.TABLE_NAME,
                c.COLUMN_NAME,
                c.DATA_TYPE,
                c.IS_NULLABLE
            FROM INFORMATION_SCHEMA.COLUMNS c
            INNER JOIN INFORMATION_SCHEMA.TABLES t
                ON c.TABLE_SCHEMA = t.TABLE_SCHEMA
               AND c.TABLE_NAME = t.TABLE_NAME
            WHERE t.TABLE_TYPE = 'BASE TABLE'
              AND c.TABLE_SCHEMA = DATABASE()
            ORDER BY c.TABLE_SCHEMA, c.TABLE_NAME, c.ORDINAL_POSITION
            """;

        var lines = new List<string> { "-- Auto-generated from INFORMATION_SCHEMA" };
        await using var connection = new MySqlConnection(_connectionString);
        await connection.OpenAsync();

        await using var command = new MySqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync();

        string? currentTable = null;
        while (await reader.ReadAsync())
        {
            string schema = reader["TABLE_SCHEMA"]?.ToString() ?? "";
            string table = reader["TABLE_NAME"]?.ToString() ?? "";
            string column = reader["COLUMN_NAME"]?.ToString() ?? "";
            string dataType = reader["DATA_TYPE"]?.ToString() ?? "";
            string nullable = reader["IS_NULLABLE"]?.ToString() ?? "";

            string tableKey = $"{schema}.{table}";
            if (tableKey != currentTable)
            {
                if (currentTable != null)
                    lines.Add(");");
                lines.Add($"CREATE TABLE `{schema}`.`{table}` (");
                currentTable = tableKey;
            }

            lines.Add($"  `{column}` {dataType} NULL={nullable},");
        }

        if (currentTable != null)
            lines.Add(");");

        return string.Join(Environment.NewLine, lines);
    }

    public static string LoadTextFile(string fileName)
    {
        string path = Path.Combine(AppContext.BaseDirectory, fileName);
        return File.Exists(path) ? File.ReadAllText(path) : "";
    }
}
