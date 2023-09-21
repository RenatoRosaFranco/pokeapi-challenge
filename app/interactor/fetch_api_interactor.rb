# frozen_string_literal: true

# FetchApiInteractor service
class FetchApiInteractor
  include Interactor

  delegate :name, to: :context

  def call
    poke_api_client = Http::PokemonApiService.new
    context.pokemon = fetch_pokemon(poke_api_client)
  end

  private

  def fetch_pokemon(api_client)
    api_client.fetch("/v2/pokemon/#{name}")
  rescue StandardError => exception
    handle_exception(exception)
  end

  def handle_exception(exception)
    Http::Exception::Handler.handle(exception, context)
  end
end
