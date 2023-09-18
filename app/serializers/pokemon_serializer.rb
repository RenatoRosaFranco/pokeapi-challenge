# frozen_string_literal: true

# Pokemon serializer class
class PokemonSerializer < ActiveModel::Serializer
  attributes :abilities

  def abilities
    return [] if object['abilities'].empty?

    object['abilities'].map do |abilities|
      abilities['ability']['name']
    end.sort
  end
end
