# frozen_string_literal: true

# Pokemon serializer class
class PokemonSerializer < ActiveModel::Serializer
  # serializer fields names
  attributes :type
  attributes :abilities

  def type
    'Pokemon'
  end

  # pokemon abilities names sorted by name
  def abilities
    object[:abilities]
      .map { |ability| ability[:ability][:name] }
      .sort_by(&:downcase)
      .presence || []
  end
end
