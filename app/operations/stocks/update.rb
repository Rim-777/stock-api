# frozen_string_literal: true

module Stocks
  class Update
    prepend BaseOperation
    include OperationErrors
    include BearerHandling

    option :id, type: Dry::Types['strict.string']

    option :stock_attributes, optional: true do
      option :name, type: Dry::Types['strict.string']
    end

    option :bearer_attributes, optional: true do
      option :name, type: Dry::Types['strict.string']
    end

    attr_reader :stock

    def call
      ActiveRecord::Base.transaction do
        set_stock!
        define_bearer
        update_stock!
      end
    end

    private

    def set_stock!
      @stock = Stock.find(@id)
    end

    def update_stock!
      @stock.lock!
      attributes = @stock_attributes ? @stock_attributes.to_h : {}
      attributes[:bearer] = @bearer if @bearer
      @stock.update!(attributes) if attributes.any?
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!(invalid_record_message('Stock', e))
    end
  end
end
