# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PokemonsController, type: :request do
  describe "GET /index" do
    subject(:response_body) { JSON.parse(response.body) }

    let(:name) { 'ditto' }

    before do
      get "/api/v1/pokemon/#{name}"
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
      let(:name) { 'radagast' }
      let(:err_message) { 'Pokemon not found' }

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
