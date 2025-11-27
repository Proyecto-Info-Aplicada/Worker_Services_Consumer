namespace Worker_Services_Consumer.Models
{
    public class LogMessage
    {
        public string Topic { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public DateTime ReceivedAt { get; set; }
        public string? CorrelationId { get; set; }
        public string? LogLevel { get; set; }
        public string? Source { get; set; }
        public Dictionary<string, string> Headers { get; set; } = new();
    }
}
