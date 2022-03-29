# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::Create do
  let(:operation) { described_class.new(params) }

  def operation_call
    operation.call
  end

  describe '#call' do
    let(:stock_name) { 'Stock' }
    let(:bearer_name) { 'Bearer' }

    let(:params) do
      {
        stock_attributes: {
          name: stock_name
        },
        bearer_attributes: {
          name: bearer_name
        }
      }
    end

    context 'success' do
      shared_examples :success do
        it_behaves_like 'operations/success'

        it 'creates a stock' do
          expect { operation_call }.to change(Stock, :count).from(0).to(1)
        end

        it 'associates a created stock with a created bearer' do
          operation.call
          bearer = Bearer.find_by!(name: bearer_name)
          stock = Stock.find_by!(name: stock_name)
          expect(stock.bearer).to eq(bearer)
        end
      end

      context 'bearer exists' do
        before do
          create(:bearer, name: bearer_name)
        end

        include_examples :success

        it 'does not create a bearer' do
          expect { operation_call }.not_to change(Bearer, :count)
        end
      end

      context 'bearer does not exist' do
        include_examples :success

        it 'creates a bearer' do
          expect { operation_call }.to change(Bearer, :count).from(0).to(1)
        end
      end
    end

    context 'failure' do
      context 'record not unique' do
        before do
          create(
            :stock,
            name: stock_name,
            bearer: create(:bearer, name: 'Any')
          )
        end

        let(:expected_error_messages) do
          ['Stock: Validation failed: Name has already been taken']
        end

        it_behaves_like 'operations/failure'

        it 'does not create stocks' do
          expect { operation_call }.not_to change(Stock, :count)
        end

        it 'does not create bearers' do
          expect { operation_call }.not_to change(Bearer, :count)
        end
      end
    end
  end
end
