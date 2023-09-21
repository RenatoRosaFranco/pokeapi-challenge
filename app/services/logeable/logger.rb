# frozen_string_literal: true

module Logeable
  class Logger
    attr_accessor :logger, :level

    def initialize(log_file, log_level)
      @logger = create_logger_instance(log_file, log_level)
    end

    def write(event, message)
      log_message(event, message)
    end

    def change_log_level(level)
      @logger.level = @level
    end

    private

    def create_logger_instance(log_file, log_level)
      logger = ::Logger.new(log_file)
      logger.level = log_level
      logger
    end

    def log_message(event, message)
      @logger.send(event, message)
    rescue StandardError => e
      handle_logging_error(e, "Failed to close logger: #{e.message}")
    end

    def close_logger
      @logger.close
    rescue StandardError => e
      handle_logging_error(e, "Failed to close logger: #{e.message}")
    end

    def handle_logging_error(error, error_message)
      set_logger_for(:error)
      @logger.write(:error, "#{error_message}: #{error.message}")
    end

    def set_logger_for(action)
      change_log_instance("log/#{action}.log", Logger.const_get(action.upcase))
    end

    def change_log_instance(log_file, log_level)
      close_logger
      @logger = create_logger_instance(log_file, log_level)
    end
  end
end
