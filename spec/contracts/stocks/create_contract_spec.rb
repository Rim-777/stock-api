# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::CreateContract do
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
    it_behaves_like 'contracts/valid_attributes'
  end

  context 'failure' do
    context '/data' do
      let(:expected_messages) do
        { key => { bearer_attributes: ['is missing'], stock_attributes: ['is missing'] } }
      end

      it_behaves_like 'contracts/invalid_root_attribute_data'
    end

    context 'dats/stock_attributes' do
      let(:key) { :stock_attributes }

      context 'missing key' do
        before do
          params[:data].delete(key)
        end

        let(:expected_messages) do
          { data: { key => ['is missing'] } }
        end

        it_behaves_like 'contracts/invalid_attribute'
      end

      it_behaves_like 'contracts/invalid_entity_attributes'
    end

    context 'data/bearer_attributes' do
      let(:key) { :bearer_attributes }

      context 'missing key' do
        before do
          params[:data].delete(key)
        end

        let(:expected_messages) do
          { data: { key => ['is missing'] } }
        end

        it_behaves_like 'contracts/invalid_attribute'
      end

      it_behaves_like 'contracts/invalid_entity_attributes'
    end
  end
end
