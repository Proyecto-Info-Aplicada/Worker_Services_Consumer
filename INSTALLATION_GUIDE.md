# 🚀 Guía de Instalación y Uso - Worker Service Kafka Consumer

## 📋 Pre-requisitos

Antes de iniciar, asegúrate de tener instalado:

1. **.NET 8.0 SDK** - [Descargar aquí](https://dotnet.microsoft.com/download/dotnet/8.0)
2. **SQL Server Express** - [Descargar aquí](https://www.microsoft.com/es-es/sql-server/sql-server-downloads)
3. **Apache Kafka** (con Zookeeper) - [Guía de instalación](#instalación-de-kafka)

---

## 🛠️ Instalación de Kafka (Windows)

### Opción 1: Usando Docker (Recomendado)

```bash
# 1. Crear archivo docker-compose.yml
version: '3'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    ports:
      - 2181:2181

  kafka:
    image: confluentinc/cp-kafka:latest
    depends_on:
      - zookeeper
    ports:
      - 9092:9092
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1

# 2. Iniciar Kafka
docker-compose up -d

# 3. Crear los topics
docker exec -it <kafka-container-id> kafka-topics --create --topic request-logs --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
docker exec -it <kafka-container-id> kafka-topics --create --topic error-logs --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
docker exec -it <kafka-container-id> kafka-topics --create --topic event-logs --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

### Opción 2: Instalación Nativa

1. Descargar Kafka desde https://kafka.apache.org/downloads
2. Extraer en `C:\kafka`
3. Iniciar Zookeeper:
   ```cmd
   cd C:\kafka
   .\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
   ```
4. Iniciar Kafka (en otra terminal):
   ```cmd
   cd C:\kafka
   .\bin\windows\kafka-server-start.bat .\config\server.properties
   ```

---

## 📦 Instalación del Worker Service

### 1. Clonar o descargar el proyecto

```bash
cd C:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto
git clone <repository-url> Worker_Services_Consumer
```

### 2. Restaurar paquetes NuGet

```bash
cd Worker_Services_Consumer
dotnet restore
```

### 3. Configurar la conexión a SQL Server

Edita `Worker_Services_Consumer/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=KafkaConsumerDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**Nota:** Ajusta el string de conexión según tu configuración de SQL Server.

### 4. Compilar el proyecto

```bash
dotnet build
```

---

## 🎯 Ejecución del Servicio

### Modo Desarrollo

```bash
cd Worker_Services_Consumer
dotnet run
```

### Modo Producción

```bash
# 1. Publicar la aplicación
dotnet publish -c Release -o ./publish

# 2. Ejecutar
cd publish
.\Worker_Services_Consumer.exe
```

---

## 📊 Verificación del Funcionamiento

### 1. Logs en Consola

Al iniciar, deberías ver:

```
╔═══════════════════════════════════════════════════════════════╗
║       🚀 KAFKA CONSUMER WORKER SERVICE INICIADO 🚀            ║
╚═══════════════════════════════════════════════════════════════╝
⏰ Intervalo de consumo: 15 segundos
✅ Base de datos inicializada correctamente
✅ Servicio inicializado correctamente
🔄 Worker ejecutándose y listo para consumir mensajes de Kafka
```

### 2. Verificar Base de Datos

```sql
-- Conectarse a SQL Server y ejecutar:
USE KafkaConsumerDB;

-- Ver tablas creadas
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Ver mensajes
SELECT TOP 10 * FROM RequestLogs ORDER BY CreatedAt DESC;
SELECT TOP 10 * FROM ErrorLogs ORDER BY CreatedAt DESC;
SELECT TOP 10 * FROM EventLogs ORDER BY CreatedAt DESC;
```

### 3. Enviar Mensajes de Prueba

#### Usando HangFireServer (Productor)

El servicio HangFireServer ya está configurado para enviar mensajes a Kafka. Solo ejecuta:

```bash
cd C:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\HangFireServer
dotnet run
```

#### Usando Kafka CLI (Manual)

```bash
# Enviar mensaje a request-logs
kafka-console-producer --broker-list localhost:9092 --topic request-logs
> {"message": "Test request", "timestamp": "2025-10-15T10:30:00"}

# Enviar mensaje a error-logs
kafka-console-producer --broker-list localhost:9092 --topic error-logs
> {"message": "Test error", "level": "ERROR"}
```

---

## ⚙️ Configuración Avanzada

### Cambiar Intervalo de Consumo

En `appsettings.json`:

```json
{
  "WorkerSettings": {
    "ConsumptionIntervalSeconds": 30  // Cambia de 15 a 30 segundos
  }
}
```

### Configurar Kafka para Producción

```json
{
  "Kafka": {
    "BootstrapServers": "kafka-prod-server:9092",
    "ConsumerGroup": "worker-consumer-group-prod",
    "AutoOffsetReset": "Latest",  // Leer solo mensajes nuevos
    "EnableAutoCommit": true       // Auto-commit de offsets
  }
}
```

---

## 🔧 Solución de Problemas Comunes

### Error: "No se puede conectar a Kafka"

**Solución:**
1. Verifica que Kafka esté corriendo: `docker ps` o verifica el proceso
2. Confirma el puerto en `appsettings.json`
3. Prueba conectividad: `telnet localhost 9092`

### Error: "No se puede conectar a SQL Server"

**Solución:**
1. Verifica que SQL Server esté corriendo
2. Revisa el string de conexión en `appsettings.json`
3. Asegúrate de tener permisos para crear bases de datos

### Error: "No se procesan mensajes"

**Solución:**
1. Verifica que existan mensajes en los topics:
   ```bash
   kafka-console-consumer --bootstrap-server localhost:9092 --topic request-logs --from-beginning
   ```
2. Revisa los logs del Worker Service
3. Verifica que el ConsumerGroup sea único

### El servicio se detiene inesperadamente

**Solución:**
1. Revisa los logs para errores específicos
2. Aumenta el timeout de sesión en `appsettings.json`:
   ```json
   {
     "Kafka": {
       "SessionTimeoutMs": 30000,
       "MaxPollIntervalMs": 600000
     }
   }
   ```

---

## 📈 Monitoreo

### Ver Estadísticas en Tiempo Real

Usa el script SQL incluido: `Scripts/QueryLogs.sql`

```sql
-- Conteo total
SELECT 
    'RequestLogs' AS TableName, COUNT(*) AS Total FROM RequestLogs
UNION ALL
SELECT 'ErrorLogs', COUNT(*) FROM ErrorLogs
UNION ALL
SELECT 'EventLogs', COUNT(*) FROM EventLogs;

-- Mensajes por hora
SELECT 
    DATEPART(HOUR, ReceivedAt) AS Hour,
    COUNT(*) AS MessageCount
FROM RequestLogs
WHERE ReceivedAt >= DATEADD(DAY, -1, GETUTCDATE())
GROUP BY DATEPART(HOUR, ReceivedAt)
ORDER BY Hour;
```

---

## 🛡️ Instalación como Servicio de Windows

Para ejecutar como servicio de Windows persistente:

```bash
# 1. Publicar
dotnet publish -c Release -o C:\Services\KafkaConsumer

# 2. Crear servicio
sc create KafkaConsumerService binPath= "C:\Services\KafkaConsumer\Worker_Services_Consumer.exe"

# 3. Iniciar servicio
sc start KafkaConsumerService

# 4. Configurar inicio automático
sc config KafkaConsumerService start= auto
```

---

## 📚 Recursos Adicionales

- [Documentación de Confluent Kafka](https://docs.confluent.io/)
- [Worker Services en .NET](https://docs.microsoft.com/en-us/dotnet/core/extensions/workers)
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)

---

## 👥 Contacto y Soporte

**Proyecto:** Información Aplicada - UCR 2025  
**Semestre:** Segundo Semestre  
**Autor:** [Tu Nombre]  
**Email:** [tu.email@ucr.ac.cr]

---

## ✅ Checklist de Verificación

- [ ] Kafka está corriendo en localhost:9092
- [ ] SQL Server está accesible
- [ ] Base de datos KafkaConsumerDB existe o se creará automáticamente
- [ ] Los 3 topics de Kafka están creados
- [ ] El Worker Service compila sin errores
- [ ] Se ven logs en la consola
- [ ] Los mensajes se guardan en SQL Server

---

¡El Worker Service está listo para consumir mensajes de Kafka! 🎉
