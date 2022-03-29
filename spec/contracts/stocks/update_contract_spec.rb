# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::UpdateContract do
  let(:validation) { described_class.new }

  let(:params) do
    {
      data: {
        stock_attributes: {
          name: 'Stock'
        },
        bearer_attributes: {
          name: 'Bearer'
        }
      }
    }
  end

  context 'success' do
    context 'with all keys' do
      it_behaves_like 'contracts/valid_attributes'
    end

    context 'stock_attributes only' do
      before do
        params[:data].delete(:bearer_attributes)
      end

      it_behaves_like 'contracts/valid_attributes'
    end

    context 'bearer_attributes only' do
      before do
        params[:data].delete(:stock_attributes)
      end

      it_behaves_like 'contracts/valid_attributes'
    end
  end

  context 'failure' do
    context '/data' do
      let(:expected_messages) do
        {
          data: [
            'One of the following attributes is missing: stock_attributes, bearer_attributes'
          ]
        }
      end

      it_behaves_like 'contracts/invalid_root_attribute_data'
    end

    context '/data/stock_attributes' do
      let(:key) { :stock_attributes }

      it_behaves_like 'contracts/invalid_entity_attributes'
    end

    context '/data/bearer_attributes' do
      let(:key) { :bearer_attributes }

      it_behaves_like 'contracts/invalid_entity_attributes'
    end
  end
end
