using Microsoft.Extensions.Options;
using Worker_Services_Consumer.Configuration;
using Worker_Services_Consumer.Services;

namespace Worker_Services_Consumer
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IKafkaConsumerService _kafkaConsumer;
        private readonly IDatabaseService _databaseService;
        private readonly WorkerSettings _workerSettings;
        private int _totalMessagesProcessed = 0;

        public Worker(
            ILogger<Worker> logger,
            IKafkaConsumerService kafkaConsumer,
            IDatabaseService databaseService,
            IOptions<WorkerSettings> workerSettings)
        {
            _logger = logger;
            _kafkaConsumer = kafkaConsumer;
            _databaseService = databaseService;
            _workerSettings = workerSettings.Value;
        }

        public override async Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("╔═══════════════════════════════════════════════════════════════╗");
            _logger.LogInformation("║       🚀 KAFKA CONSUMER WORKER SERVICE INICIADO 🚀            ║");
            _logger.LogInformation("╚═══════════════════════════════════════════════════════════════╝");
            _logger.LogInformation("⏰ Intervalo de consumo: {Interval} segundos", _workerSettings.ConsumptionIntervalSeconds);
            
            try
            {
                await _databaseService.InitializeDatabaseAsync();
                _logger.LogInformation("✅ Servicio inicializado correctamente");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "❌ Error al inicializar el servicio");
                throw;
            }

            await base.StartAsync(cancellationToken);
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("🔄 Worker ejecutándose y listo para consumir mensajes de Kafka");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var startTime = DateTime.UtcNow;
                    _logger.LogInformation("─────────────────────────────────────────────────────────────");
                    _logger.LogInformation("⏱️  Iniciando ciclo de consumo: {Time}", startTime.ToLocalTime());

                    // Consumir mensajes de Kafka
                    var messages = await _kafkaConsumer.ConsumeMessagesAsync(stoppingToken);

                    if (messages.Any())
                    {
                        _logger.LogInformation("📨 {Count} mensajes recibidos de Kafka", messages.Count);

                        // Guardar en SQL Server
                        await _databaseService.SaveLogMessagesAsync(messages);
                        
                        _totalMessagesProcessed += messages.Count;

                        // Mostrar resumen por topic
                        var topicGroups = messages.GroupBy(m => m.Topic);
                        foreach (var group in topicGroups)
                        {
                            _logger.LogInformation("   📊 Topic: {Topic} - {Count} mensajes", group.Key, group.Count());
                        }

                        // Obtener total de mensajes en BD
                        var totalInDb = await _databaseService.GetTotalMessagesCountAsync();
                        _logger.LogInformation("💾 Total de mensajes en BD: {Total}", totalInDb);
                        _logger.LogInformation("📈 Mensajes procesados en esta sesión: {Total}", _totalMessagesProcessed);
                    }
                    else
                    {
                        _logger.LogInformation("📭 No hay mensajes nuevos para procesar");
                    }

                    var endTime = DateTime.UtcNow;
                    var duration = (endTime - startTime).TotalMilliseconds;
                    _logger.LogInformation("⏱️  Ciclo completado en {Duration:F2}ms", duration);
                    _logger.LogInformation("😴 Esperando {Interval} segundos para el próximo ciclo...", _workerSettings.ConsumptionIntervalSeconds);

                    // Esperar el intervalo configurado
                    await Task.Delay(TimeSpan.FromSeconds(_workerSettings.ConsumptionIntervalSeconds), stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    _logger.LogInformation("⚠️  Operación cancelada, deteniendo el worker");
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "❌ Error durante el procesamiento de mensajes");
                    _logger.LogInformation("⏳ Esperando 30 segundos antes de reintentar...");
                    await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
                }
            }
        }

        public override async Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("╔═══════════════════════════════════════════════════════════════╗");
            _logger.LogInformation("║       🛑 KAFKA CONSUMER WORKER SERVICE DETENIDO 🛑            ║");
            _logger.LogInformation("╚═══════════════════════════════════════════════════════════════╝");
            _logger.LogInformation("📊 Total de mensajes procesados: {Total}", _totalMessagesProcessed);
            
            await base.StopAsync(cancellationToken);
        }
    }
}

