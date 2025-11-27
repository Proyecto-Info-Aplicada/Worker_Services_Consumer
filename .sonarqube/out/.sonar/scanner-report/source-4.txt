namespace Worker_Services_Consumer.Configuration
{
    public class WorkerSettings
    {
        public int ConsumptionIntervalSeconds { get; set; } = 15;
        public int BatchSize { get; set; } = 100;
    }
}
