# frozen_string_literal: true

require 'net/http'

module Http
  # Service to fetch data from PokeApi
  class PokemonApiService
    include HTTParty

    attr_reader :name

    base_uri ENV.fetch('API_URL') { 'https://pokeapi.co/api/' }

    def initialize(options = {})
      @options = { query: options }
    end

    def fetch(api_endpoint)
      response = self.class.get(api_endpoint, @options)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.code
      when 200
        parse_response(response)
      when 404
        raise_not_found_exception(response)
      else
        ranse_error_exception(response)
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def raise_not_found_exception(response)
      raise Http::Exception::NotFound, response
    end

    def raise_error_exception(response)
      raise Http::Exception::Error, response
    end
  end
end
