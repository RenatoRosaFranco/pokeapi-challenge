# frozen_string_literal: true

Rails.application.routes.draw do

  # API => https://localhost:3000/api/v1/
  namespace :api do
    namespace :v1 do
      get 'pokemon/:name' => 'pokemons#index', as: :pokemon
    end
  end
end
