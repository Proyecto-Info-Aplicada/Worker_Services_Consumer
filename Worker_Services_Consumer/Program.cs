using Worker_Services_Consumer;
using Worker_Services_Consumer.Configuration;
using Worker_Services_Consumer.Services;

var builder = Host.CreateApplicationBuilder(args);

// Configurar opciones
builder.Services.Configure<KafkaSettings>(
    builder.Configuration.GetSection("Kafka"));

builder.Services.Configure<WorkerSettings>(
    builder.Configuration.GetSection("WorkerSettings"));

// Registrar servicios
builder.Services.AddSingleton<IKafkaConsumerService, KafkaConsumerService>();
builder.Services.AddSingleton<IDatabaseService, DatabaseService>();
builder.Services.AddHostedService<Worker>();

// Configurar logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var host = builder.Build();
host.Run();
