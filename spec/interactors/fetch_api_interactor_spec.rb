# frozen_string_literal: true

require 'rails_helper'

describe FetchApiInteractor, type: :interactor do
  subject(:context) { described_class.call(data: data) }

  let(:data) { 'pikachu' }

  describe '.call' do
    context 'when fetch a pokemon' do
      it 'return a success interactor with pokemon', :aggregate_failures do
        expect(context).to be_a_success
        expect(context.pokemon).not_to be_empty
      end
    end

    context 'when fails to fetch pokemon' do
      let(:data) { 'matz' }
      let(:err_message) { 'Pokemon not found' }
      let(:status_code) { 404 }

      it 'return a error interactor with error and status_code', :aggregate_failures do
        expect(context).to be_a_failure
        expect(context.error).to eq(err_message)
        expect(context.status_code).to eq(status_code)
      end
    end
  end
end
