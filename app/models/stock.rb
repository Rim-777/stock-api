# frozen_string_literal: true

class Stock < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  belongs_to :bearer, inverse_of: :stocks
end
