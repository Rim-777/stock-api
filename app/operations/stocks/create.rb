# frozen_string_literal: true

module Stocks
  class Create
    prepend BaseOperation

    option :stock_attributes do
      option :name, type: Dry::Types['strict.string']
    end

    option :bearer_attributes do
      option :name, type: Dry::Types['strict.string']
    end

    attr_reader :result

    def call
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(<<~SQL).clear
          lock bearers in share row exclusive mode;
        SQL
        define_bearer!
        create_stock!
      end
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!(e.message)
    end

    private

    def define_bearer!
      @bearer = find_bearer || create_bearer!
    end

    def find_bearer
      Bearer.find_by(name: @bearer_attributes.name)
    end

    def create_bearer!
      Bearer.create!(@bearer_attributes.to_h)
    end

    def create_stock!
      @result = @bearer.stocks.create!(@stock_attributes.to_h)
    end
  end
end
