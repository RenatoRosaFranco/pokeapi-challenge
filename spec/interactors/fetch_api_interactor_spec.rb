# frozen_string_literal: true

require 'rails_helper'

describe FetchApiInteractor, type: :interactor do
  subject(:context) { described_class.call(name: name) }

  let(:name) { 'pikachu' }

  describe '.call' do
    context 'when fetch a pokemon' do
      it 'return a success interactor with pokemon', :aggregate_failures do
        expect(context).to be_a_success
        expect(context.pokemon).not_to be_empty
        expect(context.pokemon[:name]).to eq(name)
      end
    end

    context 'when fails to fetch pokemon' do
      let(:name) { 'matz' }
      let(:status_code) { :not_found }
      let(:err_message) { I18n.t('api.v1.errors.not_found', name: name) }

      it 'return a error interactor with error and status_code', :aggregate_failures do
        expect(context).to be_a_failure
        expect(context.error).to eq(err_message)
        expect(context.status_code).to eq(status_code)
      end
    end
  end
end
