using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Worker_Services_Consumer.Models;

namespace Worker_Services_Consumer.Services
{
    public class DatabaseService : ServiceBase, IDatabaseService
    {
        private readonly string _connectionString;

        public DatabaseService(IConfiguration configuration, ILogger<DatabaseService> logger)
            : base(logger)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection") 
                ?? throw new InvalidOperationException("Connection string not found");
        }

        public async Task InitializeDatabaseAsync()
        {
            await ExecuteWithErrorHandlingAsync(async () =>
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                var createRequestLogsTable = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RequestLogs')
                    BEGIN
                        CREATE TABLE RequestLogs (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Topic NVARCHAR(100) NOT NULL,
                            Message NVARCHAR(MAX) NOT NULL,
                            ReceivedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
                            CorrelationId NVARCHAR(100),
                            LogLevel NVARCHAR(50),
                            Source NVARCHAR(200),
                            Headers NVARCHAR(MAX),
                            CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
                        )
                        CREATE INDEX IX_RequestLogs_Topic ON RequestLogs(Topic)
                        CREATE INDEX IX_RequestLogs_ReceivedAt ON RequestLogs(ReceivedAt)
                        CREATE INDEX IX_RequestLogs_CorrelationId ON RequestLogs(CorrelationId)
                    END";

                var createErrorLogsTable = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLogs')
                    BEGIN
                        CREATE TABLE ErrorLogs (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Topic NVARCHAR(100) NOT NULL,
                            Message NVARCHAR(MAX) NOT NULL,
                            ReceivedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
                            CorrelationId NVARCHAR(100),
                            LogLevel NVARCHAR(50),
                            Source NVARCHAR(200),
                            Headers NVARCHAR(MAX),
                            CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
                        )
                        CREATE INDEX IX_ErrorLogs_Topic ON ErrorLogs(Topic)
                        CREATE INDEX IX_ErrorLogs_ReceivedAt ON ErrorLogs(ReceivedAt)
                        CREATE INDEX IX_ErrorLogs_CorrelationId ON ErrorLogs(CorrelationId)
                    END";

                var createEventLogsTable = @"
                    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EventLogs')
                    BEGIN
                        CREATE TABLE EventLogs (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Topic NVARCHAR(100) NOT NULL,
                            Message NVARCHAR(MAX) NOT NULL,
                            ReceivedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
                            CorrelationId NVARCHAR(100),
                            LogLevel NVARCHAR(50),
                            Source NVARCHAR(200),
                            Headers NVARCHAR(MAX),
                            CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
                        )
                        CREATE INDEX IX_EventLogs_Topic ON EventLogs(Topic)
                        CREATE INDEX IX_EventLogs_ReceivedAt ON EventLogs(ReceivedAt)
                        CREATE INDEX IX_EventLogs_CorrelationId ON EventLogs(CorrelationId)
                    END";

                using var command1 = new SqlCommand(createRequestLogsTable, connection);
                await command1.ExecuteNonQueryAsync();

                using var command2 = new SqlCommand(createErrorLogsTable, connection);
                await command2.ExecuteNonQueryAsync();

                using var command3 = new SqlCommand(createEventLogsTable, connection);
                await command3.ExecuteNonQueryAsync();

                LogInformation("Base de datos inicializada correctamente");
            }, "InitializeDatabaseAsync");
        }

        public async Task SaveLogMessagesAsync(List<LogMessage> messages)
        {
            ValidateNotEmpty(messages, nameof(messages));

            await ExecuteWithErrorHandlingAsync(async () =>
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                foreach (var message in messages)
                {
                    var tableName = GetTableNameByTopic(message.Topic);
                    var headersJson = JsonConvert.SerializeObject(message.Headers);

                    var insertQuery = $@"
                        INSERT INTO {tableName} 
                        (Topic, Message, ReceivedAt, CorrelationId, LogLevel, Source, Headers, CreatedAt)
                        VALUES 
                        (@Topic, @Message, @ReceivedAt, @CorrelationId, @LogLevel, @Source, @Headers, GETUTCDATE())";

                    using var command = new SqlCommand(insertQuery, connection);
                    command.Parameters.AddWithValue("@Topic", message.Topic);
                    command.Parameters.AddWithValue("@Message", message.Message);
                    command.Parameters.AddWithValue("@ReceivedAt", message.ReceivedAt);
                    command.Parameters.AddWithValue("@CorrelationId", (object?)message.CorrelationId ?? DBNull.Value);
                    command.Parameters.AddWithValue("@LogLevel", (object?)message.LogLevel ?? DBNull.Value);
                    command.Parameters.AddWithValue("@Source", (object?)message.Source ?? DBNull.Value);
                    command.Parameters.AddWithValue("@Headers", headersJson);

                    await command.ExecuteNonQueryAsync();
                }

                LogInformation("{Count} mensajes guardados en SQL Server", messages.Count);
            }, "SaveLogMessagesAsync");
        }

        public async Task<int> GetTotalMessagesCountAsync()
        {
            return await ExecuteWithErrorHandlingAsync(async () =>
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                var query = @"
                    SELECT 
                        (SELECT COUNT(*) FROM RequestLogs) + 
                        (SELECT COUNT(*) FROM ErrorLogs) + 
                        (SELECT COUNT(*) FROM EventLogs) AS TotalCount";

                using var command = new SqlCommand(query, connection);
                var result = await command.ExecuteScalarAsync();
                return Convert.ToInt32(result);
            }, "GetTotalMessagesCountAsync", defaultValue: 0);
        }

        private string GetTableNameByTopic(string topic)
        {
            return topic switch
            {
                "request-logs" => "RequestLogs",
                "error-logs" => "ErrorLogs",
                "event-logs" => "EventLogs",
                _ => "RequestLogs"
            };
        }
    }
}
