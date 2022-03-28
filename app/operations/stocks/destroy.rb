# frozen_string_literal: true

module Stocks
  class Destroy
    prepend BaseOperation

    option :id, type: Dry::Types['strict.string']

    def call
      stock = Stock.find(@id).lock!
      stock.destroy!
    rescue ActiveRecord::RecordNotDestroyed => e
      fail!(e.message)
    end
  end
end
