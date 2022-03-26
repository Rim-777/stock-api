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

    attr_reader :result

    def call
      ActiveRecord::Base.transaction do
        define_bearer
        create_stock!
      end
    end

    private

    def create_stock!
      ActiveRecord::Base.connection.execute(<<~SQL).clear
        lock stocks in share row exclusive mode;
      SQL

      @result = @bearer.stocks.create!(@stock_attributes.to_h)
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!(invalid_record_message('Stock', e))
    end
  end
end
