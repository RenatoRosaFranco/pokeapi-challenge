# frozen_string_literal: true

module Api
  module V1
    # Pokemons controller class
    class PokemonsController < ApplicationController
      def show
        cached_key  = @cache_service.generate('pokemon', params[:name])
        cached_data = @cache_service.read(cached_key)

        if cached_data.nil?
          result = FetchApiInteractor.call(name: params[:name].downcase)
          handle_fetch_result(result, cached_key)
        else
          render json: cached_data, status: :ok
        end
      end

      private

      def handle_fetch_result(result, cached_key)
        if result.success?
          serialized_pokemon = PokemonSerializer.new(result.pokemon).serializable_hash
          @cache_service.write(cached_key, serialized_pokemon)

          render json: serialized_pokemon, status: :ok
        else
          render json: { error: result.error }, status: result.status_code
        end
      end
    end
  end
end
