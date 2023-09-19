# frozen_string_literal: true

module Http
  module Cacheable
    CACHE_EXPIRATION_TIME = 1.hour

    def generate_cache(suffix, name)
      "#{suffix}_#{name}"
    end

    def read_cache(cache_key)
      Rails.cache.read(cache_key)
    end

    def write_cache(cache_key, serialized_object, expiration = CACHE_EXPIRATION_TIME)
      Rails.cache.write(cache_key, serialized_object, expires_in: expiration)
    end
  end
end
