# frozen_string_literal: true

module Api
  module V1
    class StocksController < BaseController
      before_action :validate_create_params, only: :create
      before_action :validate_update_params, only: :update

      def index
        stocks = Stocks::Index.call.result.page(params[:page])
        serializer = StockSerializer.new(
          stocks, include: [:bearer],
                  links: pagination_links(stocks)
        )

        render json: serializer.serialized_json
      end

      def create
        operation = Stocks::Create.call(@valid_params[:data])
        if operation.success?
          serializer = StockSerializer.new(
            operation.stock, include: [:bearer]
          )

          render json: serializer.serialized_json, status: :created
        else
          messages = operation.errors
          error_response(messages, :unprocessable_entity)
        end
      end

      def update
        operation = Stocks::Update.call(@valid_params[:data].merge(id: params[:id]))
        if operation.success?
          serializer = StockSerializer.new(
            operation.stock, include: [:bearer]
          )

          render json: serializer.serialized_json, status: :ok
        else
          messages = operation.errors
          error_response(messages, :unprocessable_entity)
        end
      end

      def destroy
        operation = Stocks::Destroy.call(id: params[:id])
        if operation.success?
          head 204
        else
          messages = operation.errors
          error_response(messages, :unprocessable_entity)
        end
      end

      private

      def stock_params
        params.permit(data: {}).to_h
      end

      def validate_create_params
        validation = Stocks::CreateContract.new.call(stock_params)
        result_validation(validation)
      end

      def validate_update_params
        validation = Stocks::UpdateContract.new.call(stock_params)
        result_validation(validation)
      end
    end
  end
end
