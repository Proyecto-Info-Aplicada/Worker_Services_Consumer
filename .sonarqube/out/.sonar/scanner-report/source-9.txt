using Worker_Services_Consumer.Models;

namespace Worker_Services_Consumer.Services
{
    public interface IKafkaConsumerService
    {
        Task<List<Models.LogMessage>> ConsumeMessagesAsync(CancellationToken cancellationToken);
    }
}
