# frozen_string_literal: true

class StockSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  belongs_to :bearer
end
