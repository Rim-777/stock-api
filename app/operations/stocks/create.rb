# frozen_string_literal: true

module Stocks
  class Create
    prepend BaseOperation
    include OperationErrors
    include BearerHandling

    option :stock_attributes do
      option :name, type: Dry::Types['strict.string']
    end

    option :bearer_attributes do
      option :name, type: Dry::Types['strict.string']
    end

    attr_reader :stock

    def call
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(<<~SQL).clear
          lock bearers in share row exclusive mode;
          lock stocks in share row exclusive mode;
        SQL

        define_bearer
        create_stock!
      end
    end

    private

    def create_stock!
      @stock = @bearer.stocks.create!(@stock_attributes.to_h)
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!(invalid_record_message('Stock', e))
    end
  end
end
