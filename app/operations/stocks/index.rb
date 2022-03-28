# frozen_string_literal: true

module Stocks
  class Index
    prepend BaseOperation

    attr_reader :result

    def call
      @result = Stock.includes(:bearer)
    end
  end
end
