# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :person, null: false, foreign_key: true
      t.references :friend, index: true

      t.timestamps
    end
  end
end
