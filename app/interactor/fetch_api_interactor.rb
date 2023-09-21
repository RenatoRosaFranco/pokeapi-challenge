# frozen_string_literal: true

# FetchApiInteractor service
class FetchApiInteractor
  include Interactor

  delegate :name, to: :context

  def call
    poke_api_client = Http::PokemonApiService.new(name)
    context.pokemon = poke_api_client.fetch("/v2/pokemon/#{name}")
  rescue StandardError => exception
    failure_context = Http::Exception::Handler.handle(exception, context)
  end
end
