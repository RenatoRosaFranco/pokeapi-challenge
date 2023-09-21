# frozen_string_literal: true

module Http
  module Cache
    class CacheService
      def initialize
        @logger = Logeable::Logger.new('log/cache.log', Logger::INFO)
        @cache  = Rails.cache
      end

      def generate(suffix, name)
        "#{suffix}_#{name}"
      end

      def read(cache_key)
        @logger.write(:info, "Cache key #{cache_key} readed at #{Time.now}")
        Rails.cache.read(cache_key)
      end

      def write(cache_key, serialized_object, expiration = 1.minute)
        @logger.write(:info, "Cache Key create for #{cache_key} at #{Time.now}")
        Rails.cache.write(cache_key, serialized_object, expires_in: expiration)
      end
    end
  end
end
