class SecretFile
  def initialize(secret_data, logger)
    @data = secret_data
    @logger = logger
  end

  def data
    @logger.create_log_entry
    @data
  end
end

# any access to data must result in a log entry being generated

class SecurityLogger
  def create_log_entry
    # ... code omitted ...
  end
end
