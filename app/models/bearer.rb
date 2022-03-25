# frozen_string_literal: true

class Bearer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :stocks,
           inverse_of: :bearer,
           dependent: :destroy
end
