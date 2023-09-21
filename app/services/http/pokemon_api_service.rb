# frozen_string_literal: true

require 'net/http'

module Http
  # Service to fetch data from PokeApi
  class PokemonApiService
    include HTTParty

    attr_reader :api_url

    def initialize(api_url = ENV.fetch('API_URL') { 'https://pokeapi.co/api/' })
      @api_url = api_url
    end

    def fetch(api_endpoint, method = :get, options = {})
      response = self.class.send(method, "#{api_url}#{api_endpoint}", **options)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.code
      when 200
        parse_response(response)
      when 404 
        raise Http::Exception::NotFound, response
      else 
        raise Http::Exception::Error, response
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
