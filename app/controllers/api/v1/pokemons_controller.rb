# frozen_string_literal: true

module Api
  module V1
    # Pokemons controller class
    class PokemonsController < ApplicationController
      include Http::Cacheable

      def index
        cache_key   = generate_cache('pokemon', params[:name])
        cached_data = read_cache(cache_key)

        if cached_data.nil?
          result = FetchApiInteractor.call(data: params[:name].downcase)

          if result.success?
            serialized_pokemon = PokemonSerializer.new(result.pokemon).serializable_hash
            write_cache(cache_key, serialized_pokemon)

            render json: serialized_pokemon, status: :ok
          else
            render json: { error: result.error }, status: result.status_code
          end
        else
          render json: cached_data, status: :ok
        end
      end
    end
  end
end
