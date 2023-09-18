# frozen_string_literal: true

module Api
  module V1
    # Pokemons controller class
    class PokemonsController < ApplicationController
      # GET /index
      def index
        data   = params[:name].downcase.to_s
        result = FetchApiInteractor.call(data: data)

        if result.success?
          render json: PokemonSerializer.new(result.pokemon).serializable_hash
        else
          render json: { error: result.error }, status: result.status_code
        end
      end
    end
  end
end
