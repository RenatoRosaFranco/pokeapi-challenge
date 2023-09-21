# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PokemonsController, type: :request do
  describe "GET /index" do
    subject(:response_body) { JSON.parse(response.body) }

    let(:pokemon_name) { 'ditto' }

    before { get "/api/v1/pokemons/#{pokemon_name}" }

    context 'when pokemon previously found in the cache' do
      let(:pokemon_name) { 'pikachu' }
      let(:cache_key) { "pokemon_#{pokemon_name}" }
      let(:cached_data) do
        {
          abilities: ['lightning-rod', 'static']
        }.as_json
      end

      before do
        allow(Rails.cache).to receive(:read).with(cache_key) { cached_data }
      end

      it 'return pokemon from cache', :aggregate_failures do
        get "/api/v1/pokemons/#{pokemon_name}"

        expect(response).to have_http_status(:success)
        expect(response_body).to eq(cached_data)
      end
    end

    context 'when pokemon name is valid' do
      let(:pokemon) do
        {
          abilities: ['imposter', 'limber']
        }.as_json
      end

      it 'returns a sucessfull response (200)', :aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response_body).not_to be_empty
      end

      it 'returns pokemon JSON structure' do
        expect(response_body).to include(pokemon)
      end

      it 'render JSON response' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when pokemon name is invalid' do
      let(:pokemon_name) { 'radagast' }
      let(:err_message) do 
        I18n.t('api.v1.errors.not_found', name: pokemon_name)
      end

      it 'returns a not found status (404)', :aggregate_failures do
        expect(response).to have_http_status(:not_found)
        expect(response_body).not_to be_empty
      end

      it 'returns not found error message' do
        expect(response_body).to include({"error" => err_message})
      end
    end
  end
end
