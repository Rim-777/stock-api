# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::Destroy do
  let(:operation) { described_class.new(params) }

  describe '#call' do
    let!(:bearer) { create(:bearer, name: 'Bearer') }
    let!(:stock) { create(:stock, name: 'Stock', bearer: bearer) }
    let(:params) { { id: stock.id } }

    def operation_call
      operation.call
    end

    context 'success' do
      it_behaves_like 'operations/success'

      it 'destroys a stock' do
        expect { operation_call }.to change(Stock, :count).from(1).to(0)
      end

      it 'destroys a stock for a related bearer' do
        expect { operation_call }.to change(bearer.stocks, :count).from(1).to(0)
      end

      it 'does not a destroy a related bearer ' do
        expect { operation_call }.not_to change(Bearer, :count)
      end
    end

    context 'failure' do
      let(:message) { 'Record cannot be destroyed' }

      before do
        allow(Stock).to receive(:find).and_return(stock)
        allow(stock)
          .to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed, message)
      end

      let(:expected_error_messages) { [message] }
      it_behaves_like 'operations/failure'

      it 'does not destroy the stock' do
        expect { operation_call }.not_to change(Stock, :count)
      end
    end
  end
end
