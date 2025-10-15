namespace Worker_Services_Consumer.Services
{
    public abstract class ServiceBase
    {
        protected readonly ILogger _logger;

        protected ServiceBase(ILogger logger)
        {
            _logger = logger;
        }

        protected void LogError(Exception ex, string message, params object[] args)
        {
            _logger.LogError(ex, message, args);
        }

        protected void LogInformation(string message, params object[] args)
        {
            _logger.LogInformation(message, args);
        }

        protected void LogWarning(Exception? ex, string message, params object[] args)
        {
            if (ex != null)
                _logger.LogWarning(ex, message, args);
            else
                _logger.LogWarning(message, args);
        }

        protected async Task<T> ExecuteWithErrorHandlingAsync<T>(
            Func<Task<T>> operation,
            string operationName,
            T? defaultValue = default)
        {
            try
            {
                return await operation();
            }
            catch (Exception ex)
            {
                LogError(ex, "Error en operación: {OperationName}", operationName);
                
                if (defaultValue != null)
                    return defaultValue;
                
                throw;
            }
        }

        protected async Task ExecuteWithErrorHandlingAsync(
            Func<Task> operation,
            string operationName,
            bool suppressException = false)
        {
            try
            {
                await operation();
            }
            catch (Exception ex)
            {
                LogError(ex, "Error en operación: {OperationName}", operationName);
                
                if (!suppressException)
                    throw;
            }
        }

        protected T ExecuteWithErrorHandling<T>(
            Func<T> operation,
            string operationName,
            T? defaultValue = default)
        {
            try
            {
                return operation();
            }
            catch (Exception ex)
            {
                LogError(ex, "Error en operación: {OperationName}", operationName);
                
                if (defaultValue != null)
                    return defaultValue;
                
                throw;
            }
        }

        protected void ExecuteWithErrorHandling(
            Action operation,
            string operationName,
            bool suppressException = false)
        {
            try
            {
                operation();
            }
            catch (Exception ex)
            {
                LogError(ex, "Error en operación: {OperationName}", operationName);
                
                if (!suppressException)
                    throw;
            }
        }

        protected void ValidateNotNull<T>(T value, string parameterName) where T : class
        {
            if (value == null)
            {
                var ex = new ArgumentNullException(parameterName);
                LogError(ex, "Parámetro nulo: {ParameterName}", parameterName);
                throw ex;
            }
        }

        protected void ValidateNotEmpty<T>(IEnumerable<T> collection, string parameterName)
        {
            if (collection == null || !collection.Any())
            {
                var ex = new ArgumentException($"La colección '{parameterName}' está vacía o es nula", parameterName);
                LogError(ex, "Colección vacía: {ParameterName}", parameterName);
                throw ex;
            }
        }
    }
}
