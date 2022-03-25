# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::Create do
  let(:operation) { described_class.new(params) }

  describe '#call' do
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
      shared_examples :success do
        it 'looks like a success' do
          expect(operation.call).to be_success
        end

        it 'does not have errors' do
          expect(operation.call.errors).to be_empty
        end

        it 'creates a stock' do
          expect { operation.call }.to change(Stock, :count).from(0).to(1)
        end

        it 'associates a created stock with a a created bearer' do
          operation.call
          bearer = Bearer.find_by!(name: params[:bearer_attributes][:name])
          stock = Stock.find_by!(name: params[:stock_attributes][:name])
          expect(stock.bearer).to eq(bearer)
        end
      end

      context 'bearer exists' do
        before do
          create(:bearer, name: params[:bearer_attributes][:name])
        end

        include_examples :success

        it 'creates a bearer' do
          expect { operation.call }.not_to change(Bearer, :count)
        end
      end

      context 'bearer does not exist' do
        include_examples :success

        it 'creates a bearer' do
          expect { operation.call }.to change(Bearer, :count).from(0).to(1)
        end
      end
    end

    context 'failure' do
      before do
        create(:stock,
               name: params[:stock_attributes][:name],
               bearer: create(:bearer, name: 'Test'))
      end

      it 'looks like failure' do
        expect(operation.call).to be_failure
      end

      it 'contains errors' do
        expect(operation.call.errors).to eq(['Validation failed: Name has already been taken'])
      end

      it 'does not create stocks' do
        expect { operation.call }.not_to change(Stock, :count)
      end

      it 'does not create bearers' do
        expect { operation.call }.not_to change(Bearer, :count)
      end
    end
  end
end
