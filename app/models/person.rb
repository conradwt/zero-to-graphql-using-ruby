# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
end
