# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :person, PersonType, null: true do
      description 'Find a person by ID'
      argument :id, ID, required: true
    end

    def person(id:)
      Person.find(id)
    end
  end
end
