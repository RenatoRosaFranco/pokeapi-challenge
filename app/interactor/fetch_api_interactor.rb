# frozen_string_literal: true

# FetchApiInteractor service
class FetchApiInteractor
  include Interactor

  delegate :data, to: :context

  def call
    poke_api_client = Http::PokemonApiService.new(data)
    context.pokemon = poke_api_client.pokemon
  rescue Http::Exception::NotFound
    context.fail!(error: t_pokemon, status_code: 404)
  rescue Http::Exception::Error => e
    context.fail!(error: e.message, status_code: 500)
  end

  private

  def t_pokemon
    'Pokemon not found'
  end
end
