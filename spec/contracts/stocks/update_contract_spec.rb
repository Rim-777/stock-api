# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::UpdateContract do
  let(:validation) { described_class.new }

  let(:params) do
    {
      stock_attributes: {
        name: 'Stock'
      },
      bearer_attributes: {
        name: 'Bearer'
      }
    }
  end

  context 'success' do
    context 'with optional keys' do
      it_behaves_like 'contracts/valid_attributes'
    end

    context 'without optional keys' do
      let(:params) { {} }
      it_behaves_like 'contracts/valid_attributes'
    end
  end

  context 'failure' do
    context '/stock_attributes' do
      let(:key) { :stock_attributes }

      it_behaves_like 'contracts/invalid_entity_attributes'
    end

    context '/bearer_attributes' do
      let(:key) { :bearer_attributes }

      it_behaves_like 'contracts/invalid_entity_attributes'
    end
  end
end
