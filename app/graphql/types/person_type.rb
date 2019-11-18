# frozen_string_literal: true

module Types
  class PersonType < Types::BaseObject
    field :id, ID,
          null: false,
          description: 'unique identifier for the person'

    field :first_name, String,
          null: false,
          description: 'first name of a person'

    field :last_name, String,
          null: false,
          description: 'last name of a person'

    field :username, String,
          null: false,
          description: 'username of a person'

    field :email, String,
          null: false,
          description: 'email of a person'

    field :friends, [Types::PersonType],
          null: false,
          description: 'a list of friends for our person'

    def friends
      object.friends
    end
  end
end
