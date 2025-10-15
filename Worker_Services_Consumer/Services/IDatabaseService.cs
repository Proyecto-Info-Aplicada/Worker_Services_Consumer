using Worker_Services_Consumer.Models;

namespace Worker_Services_Consumer.Services
{
    public interface IDatabaseService
    {
        Task InitializeDatabaseAsync();
        Task SaveLogMessagesAsync(List<LogMessage> messages);
        Task<int> GetTotalMessagesCountAsync();
    }
}
