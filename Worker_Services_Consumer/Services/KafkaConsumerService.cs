using Confluent.Kafka;
using Microsoft.Extensions.Options;
using System.Text;
using Worker_Services_Consumer.Configuration;
using Worker_Services_Consumer.Models;

namespace Worker_Services_Consumer.Services
{
    public class KafkaConsumerService : IKafkaConsumerService, IDisposable
    {
        private readonly KafkaSettings _kafkaSettings;
        private readonly WorkerSettings _workerSettings;
        private readonly ILogger<KafkaConsumerService> _logger;
        private readonly List<IConsumer<Ignore, string>> _consumers = new();

        public KafkaConsumerService(
            IOptions<KafkaSettings> kafkaSettings,
            IOptions<WorkerSettings> workerSettings,
            ILogger<KafkaConsumerService> logger)
        {
            _kafkaSettings = kafkaSettings.Value;
            _workerSettings = workerSettings.Value;
            _logger = logger;

            InitializeConsumers();
        }

        private void InitializeConsumers()
        {
            var config = new ConsumerConfig
            {
                BootstrapServers = _kafkaSettings.BootstrapServers,
                GroupId = _kafkaSettings.ConsumerGroup,
                AutoOffsetReset = Enum.Parse<AutoOffsetReset>(_kafkaSettings.AutoOffsetReset),
                EnableAutoCommit = _kafkaSettings.EnableAutoCommit,
                SessionTimeoutMs = _kafkaSettings.SessionTimeoutMs,
                MaxPollIntervalMs = _kafkaSettings.MaxPollIntervalMs
            };

            // Crear consumidores para cada tópico
            var topics = new[] 
            { 
                _kafkaSettings.RequestLogsTopic, 
                _kafkaSettings.ErrorLogsTopic, 
                _kafkaSettings.EventLogsTopic 
            };

            foreach (var topic in topics)
            {
                var consumer = new ConsumerBuilder<Ignore, string>(config)
                    .SetErrorHandler((_, error) =>
                        _logger.LogError("Error en consumidor Kafka para {Topic}: {Reason}", topic, error.Reason))
                    .Build();

                consumer.Subscribe(topic);
                _consumers.Add(consumer);
                _logger.LogInformation("Consumidor suscrito al topic: {Topic}", topic);
            }
        }

        public Task<List<Models.LogMessage>> ConsumeMessagesAsync(CancellationToken cancellationToken)
        {
            var messages = new List<Models.LogMessage>();

            foreach (var consumer in _consumers)
            {
                try
                {
                    var consumeResult = consumer.Consume(TimeSpan.FromSeconds(1));
                    
                    if (consumeResult != null && !consumeResult.IsPartitionEOF)
                    {
                        var logMessage = new Models.LogMessage
                        {
                            Topic = consumeResult.Topic,
                            Message = consumeResult.Message.Value,
                            ReceivedAt = DateTime.UtcNow,
                            Headers = ExtractHeaders(consumeResult.Message.Headers)
                        };

                        // Extraer información adicional de los headers
                        if (logMessage.Headers.ContainsKey("CorrelationId"))
                            logMessage.CorrelationId = logMessage.Headers["CorrelationId"];
                        
                        if (logMessage.Headers.ContainsKey("LogLevel"))
                            logMessage.LogLevel = logMessage.Headers["LogLevel"];
                        
                        if (logMessage.Headers.ContainsKey("Source"))
                            logMessage.Source = logMessage.Headers["Source"];

                        messages.Add(logMessage);

                        _logger.LogInformation(
                            "✅ Mensaje consumido del topic {Topic}: Offset={Offset}, Partition={Partition}",
                            consumeResult.Topic,
                            consumeResult.Offset.Value,
                            consumeResult.Partition.Value);

                        // Commit manual del offset
                        if (!_kafkaSettings.EnableAutoCommit)
                        {
                            consumer.Commit(consumeResult);
                        }
                    }
                }
                catch (ConsumeException ex)
                {
                    _logger.LogError(ex, "❌ Error al consumir mensaje: {Reason}", ex.Error.Reason);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "❌ Error inesperado al consumir mensaje");
                }
            }

            return Task.FromResult(messages);
        }

        private Dictionary<string, string> ExtractHeaders(Headers headers)
        {
            var headerDict = new Dictionary<string, string>();
            
            if (headers != null)
            {
                foreach (var header in headers)
                {
                    try
                    {
                        var value = Encoding.UTF8.GetString(header.GetValueBytes());
                        headerDict[header.Key] = value;
                    }
                    catch (Exception ex)
                    {
                        _logger.LogWarning(ex, "No se pudo leer el header {Key}", header.Key);
                    }
                }
            }

            return headerDict;
        }

        public void Dispose()
        {
            foreach (var consumer in _consumers)
            {
                try
                {
                    consumer?.Close();
                    consumer?.Dispose();
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error al cerrar consumidor");
                }
            }
            
            _consumers.Clear();
        }
    }
}
