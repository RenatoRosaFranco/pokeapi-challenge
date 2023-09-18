# frozen_string_literal: true

require 'net/http'

module Http
  # Service to fetch data from PokeApi
  class PokemonApiService
    include HTTParty
    base_uri ENV.fetch('API_URL', 'https://pokeapi.co/api/')

    def initialize(name, page = 1)
      @name = name
      @options = { query: { page: page } }
    end

    def pokemon
      response = self.class.get("/v2/pokemon/#{@name}", @options)

      case response.code
      when 200
        JSON.parse(response.body)
      when 404
        raise Http::Exception::NotFound, response
      else
        raise Http::Exception::Error, response
      end
    end
  end
end
