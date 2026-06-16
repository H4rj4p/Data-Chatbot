using System.Text.RegularExpressions;

public static class SqlSafety
{
    private static readonly string[] BlockedKeywords =
    {
        "INSERT", "UPDATE", "DELETE", "DROP", "TRUNCATE", "ALTER",
        "CREATE", "EXEC", "EXECUTE", "MERGE", "GRANT", "REVOKE", "INTO"
    };

    public static bool TryValidateSelectQuery(string sql, out string error)
    {
        error = "";

        if (string.IsNullOrWhiteSpace(sql))
        {
            error = "Query is empty.";
            return false;
        }

        sql = sql.Trim().TrimEnd(';');

        if (!sql.StartsWith("SELECT", StringComparison.OrdinalIgnoreCase))
        {
            error = "Only SELECT queries are allowed.";
            return false;
        }

        if (sql.Contains(';'))
        {
            error = "Multiple SQL statements are not allowed.";
            return false;
        }

        foreach (var keyword in BlockedKeywords)
        {
            if (Regex.IsMatch(sql, $@"\b{keyword}\b", RegexOptions.IgnoreCase))
            {
                error = $"Blocked keyword detected: {keyword}.";
                return false;
            }
        }

        return true;
    }

    public static string CleanSql(string sql)
    {
        if (string.IsNullOrWhiteSpace(sql)) return "NA";

        return sql
            .Replace("```json", "", StringComparison.OrdinalIgnoreCase)
            .Replace("```sql", "", StringComparison.OrdinalIgnoreCase)
            .Replace("```", "")
            .Trim()
            .TrimEnd(';');
    }
}
