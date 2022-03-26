# frozen_string_literal: true

module Stocks
  class UpdateContract < Dry::Validation::Contract
    schema do
      optional(:stock_attributes).hash do
        required(:name).filled(:string)
      end

      optional(:bearer_attributes).hash do
        required(:name).filled(:string)
      end
    end
  end
end
