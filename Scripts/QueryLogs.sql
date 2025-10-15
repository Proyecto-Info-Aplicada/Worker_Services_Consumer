-- Script para consultar y analizar los logs almacenados desde Kafka
-- Worker Services Consumer - UCR 2025

-- ============================================
-- 1. VERIFICAR CONTEO TOTAL DE MENSAJES
-- ============================================
SELECT 
    'RequestLogs' AS TableName, 
    COUNT(*) AS TotalMessages
FROM RequestLogs
UNION ALL
SELECT 
    'ErrorLogs' AS TableName, 
    COUNT(*) AS TotalMessages
FROM ErrorLogs
UNION ALL
SELECT 
    'EventLogs' AS TableName, 
    COUNT(*) AS TotalMessages
FROM EventLogs;

-- ============================================
-- 2. ÚLTIMOS 10 MENSAJES DE REQUEST LOGS
-- ============================================
SELECT TOP 10
    Id,
    Topic,
    LEFT(Message, 100) AS MessagePreview,
    CorrelationId,
    LogLevel,
    Source,
    ReceivedAt,
    CreatedAt
FROM RequestLogs
ORDER BY CreatedAt DESC;

-- ============================================
-- 3. ÚLTIMOS 10 MENSAJES DE ERROR LOGS
-- ============================================
SELECT TOP 10
    Id,
    Topic,
    LEFT(Message, 100) AS MessagePreview,
    CorrelationId,
    LogLevel,
    Source,
    ReceivedAt,
    CreatedAt
FROM ErrorLogs
ORDER BY CreatedAt DESC;

-- ============================================
-- 4. ÚLTIMOS 10 MENSAJES DE EVENT LOGS
-- ============================================
SELECT TOP 10
    Id,
    Topic,
    LEFT(Message, 100) AS MessagePreview,
    CorrelationId,
    LogLevel,
    Source,
    ReceivedAt,
    CreatedAt
FROM EventLogs
ORDER BY CreatedAt DESC;

-- ============================================
-- 5. ESTADÍSTICAS POR HORA
-- ============================================
SELECT 
    'RequestLogs' AS TableName,
    DATEPART(HOUR, ReceivedAt) AS Hour,
    COUNT(*) AS MessageCount
FROM RequestLogs
WHERE ReceivedAt >= DATEADD(DAY, -1, GETUTCDATE())
GROUP BY DATEPART(HOUR, ReceivedAt)
ORDER BY Hour;

-- ============================================
-- 6. BUSCAR POR CORRELATION ID
-- ============================================
-- Reemplaza 'YOUR_CORRELATION_ID' con el ID que buscas
DECLARE @CorrelationId NVARCHAR(100) = 'YOUR_CORRELATION_ID';

SELECT 'RequestLogs' AS Source, * FROM RequestLogs WHERE CorrelationId = @CorrelationId
UNION ALL
SELECT 'ErrorLogs' AS Source, * FROM ErrorLogs WHERE CorrelationId = @CorrelationId
UNION ALL
SELECT 'EventLogs' AS Source, * FROM EventLogs WHERE CorrelationId = @CorrelationId
ORDER BY ReceivedAt;

-- ============================================
-- 7. MENSAJES MÁS RECIENTES (TODAS LAS TABLAS)
-- ============================================
SELECT TOP 20
    'RequestLogs' AS Source,
    Id,
    Topic,
    LEFT(Message, 150) AS MessagePreview,
    CorrelationId,
    ReceivedAt
FROM RequestLogs
UNION ALL
SELECT TOP 20
    'ErrorLogs' AS Source,
    Id,
    Topic,
    LEFT(Message, 150) AS MessagePreview,
    CorrelationId,
    ReceivedAt
FROM ErrorLogs
UNION ALL
SELECT TOP 20
    'EventLogs' AS Source,
    Id,
    Topic,
    LEFT(Message, 150) AS MessagePreview,
    CorrelationId,
    ReceivedAt
FROM EventLogs
ORDER BY ReceivedAt DESC;

-- ============================================
-- 8. LIMPIAR DATOS ANTIGUOS (OPCIONAL)
-- ============================================
-- CUIDADO: Esto eliminará datos permanentemente
-- Descomenta solo si estás seguro

-- DELETE FROM RequestLogs WHERE ReceivedAt < DATEADD(DAY, -30, GETUTCDATE());
-- DELETE FROM ErrorLogs WHERE ReceivedAt < DATEADD(DAY, -30, GETUTCDATE());
-- DELETE FROM EventLogs WHERE ReceivedAt < DATEADD(DAY, -30, GETUTCDATE());

-- ============================================
-- 9. ANÁLISIS DE PERFORMANCE
-- ============================================
SELECT 
    'RequestLogs' AS TableName,
    COUNT(*) AS TotalMessages,
    MIN(ReceivedAt) AS FirstMessage,
    MAX(ReceivedAt) AS LastMessage,
    DATEDIFF(MINUTE, MIN(ReceivedAt), MAX(ReceivedAt)) AS MinuteSpan
FROM RequestLogs
UNION ALL
SELECT 
    'ErrorLogs' AS TableName,
    COUNT(*) AS TotalMessages,
    MIN(ReceivedAt) AS FirstMessage,
    MAX(ReceivedAt) AS LastMessage,
    DATEDIFF(MINUTE, MIN(ReceivedAt), MAX(ReceivedAt)) AS MinuteSpan
FROM ErrorLogs
UNION ALL
SELECT 
    'EventLogs' AS TableName,
    COUNT(*) AS TotalMessages,
    MIN(ReceivedAt) AS FirstMessage,
    MAX(ReceivedAt) AS LastMessage,
    DATEDIFF(MINUTE, MIN(ReceivedAt), MAX(ReceivedAt)) AS MinuteSpan
FROM EventLogs;

-- ============================================
-- 10. MENSAJE COMPLETO POR ID
-- ============================================
-- Reemplaza '1' con el ID que quieres ver
DECLARE @MessageId INT = 1;

SELECT * FROM RequestLogs WHERE Id = @MessageId
UNION ALL
SELECT * FROM ErrorLogs WHERE Id = @MessageId
UNION ALL
SELECT * FROM EventLogs WHERE Id = @MessageId;
