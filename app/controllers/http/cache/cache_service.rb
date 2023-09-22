# frozen_string_literal: true

module Http
  module Cache
    # Custom cache service class
    class CacheService
      attr_reader :logger, :cache

      def initialize(logger, cache)
        @logger = logger
        @cache  = cache
      end

      def generate(suffix, name)
        "#{suffix}_#{name}"
      end

      def read(cache_key)
        logger.level = Logger::INFO
        logger.write(:info, "Cache key #{cache_key} readed")
        cache.read(cache_key)
      rescue StandardError => e
        logger.level = Logger::ERROR
        logger.write(:error, "Failed to read cache key #{e.message}")
      end

      def write(cache_key, serialized_object, expiration = 1.minute)
        logger.level = Logger::INFO
        logger.write(:info, "Cache Key create for #{cache_key}")
        cache.write(cache_key, serialized_object, expires_in: expiration)
      rescue StandardError => e
        logger.level = Logger::ERROR
        logger.write(:error, "Failed to write cache key #{e.message}")
      end
    end
  end
end
