# frozen_string_literal: true

module Stocks
  class CreateContract < Dry::Validation::Contract
    schema do
      required(:stock_attributes).hash do
        required(:name).filled(:string)
      end

      required(:bearer_attributes).hash do
        required(:name).filled(:string)
      end
    end
  end
end
