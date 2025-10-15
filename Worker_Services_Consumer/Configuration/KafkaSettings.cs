namespace Worker_Services_Consumer.Configuration
{
    public class KafkaSettings
    {
        public string BootstrapServers { get; set; } = string.Empty;
        public string RequestLogsTopic { get; set; } = string.Empty;
        public string ErrorLogsTopic { get; set; } = string.Empty;
        public string EventLogsTopic { get; set; } = string.Empty;
        public string ConsumerGroup { get; set; } = string.Empty;
        public string AutoOffsetReset { get; set; } = "Earliest";
        public bool EnableAutoCommit { get; set; } = false;
        public int SessionTimeoutMs { get; set; } = 10000;
        public int MaxPollIntervalMs { get; set; } = 300000;
    }
}
