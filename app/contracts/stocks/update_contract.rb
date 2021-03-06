# frozen_string_literal: true

module Stocks
  class UpdateContract < Dry::Validation::Contract
    schema do
      required(:data).hash do
        optional(:stock_attributes).hash do
          required(:name).filled(:string)
        end

        optional(:bearer_attributes).hash do
          required(:name).filled(:string)
        end
      end
    end

    rule(%i[data]) do
      if value.empty?
        message =
          I18n.t(
            :missing_attributes,
            scope: 'errors',
            attributes: 'stock_attributes, bearer_attributes'
          )

        key(%i[data]).failure(message)
      end
    end
  end
end
