# frozen_string_literal: true

# Pokemon serializer class
class PokemonSerializer < ActiveModel::Serializer
  # serializer fields names
  attributes :abilities

  # pokemon abilities names sorted by name
  def abilities
    object[:abilities]
      .map { |ability| ability[:ability][:name] }
      .sort
      .presence || []
  end
end
