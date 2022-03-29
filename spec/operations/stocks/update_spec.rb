# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::Update do
  let(:operation) { described_class.new(params) }

  describe '#call' do
    let(:old_stock_name) { 'Stock' }
    let!(:bearer) { create(:bearer, name: 'Bearer') }
    let!(:stock) { create(:stock, name: old_stock_name, bearer: bearer) }
    let(:params) { { id: stock.id } }

    let(:new_bearer_name) { 'New Bearer' }
    let(:new_stock_name) { 'New Stock' }

    def operation_call
      operation.call
    end

    shared_examples :creates_new_bearer do
      it 'creates a new bearer' do
        expect { operation_call }.to change(Bearer, :count).from(1).to(2)
      end
    end

    shared_examples :updates_stock_name do
      it 'updates a the stock' do
        expect do
          operation_call
          stock.reload
        end.to change(stock, :name).from(old_stock_name).to(new_stock_name)
      end
    end

    shared_examples :does_not_create_bearers do
      it 'does not create a new bearer' do
        expect { operation_call }.not_to change(Bearer, :count)
      end
    end

    shared_examples :does_not_update_stock_name do
      it 'does not update a the stock' do
        expect do
          operation_call
          stock.reload
        end.not_to change(stock, :name)
      end
    end

    shared_examples :associates_stock_with_bearer do
      it 'associates the stock wth a new bearer' do
        operation_call
        new_bearer = Bearer.find_by(name: new_bearer_name)
        stock.reload
        expect(stock.bearer).to eq(new_bearer)
      end
    end

    context 'success' do
      context 'bearer and stock attributes are present' do
        before do
          params[:stock_attributes] = {
            name: new_stock_name
          }
          params[:bearer_attributes] = {
            name: new_bearer_name
          }
        end

        it_behaves_like 'operations/success'

        include_examples :creates_new_bearer

        it 'does not update existing bearer' do
          expect do
            operation_call
            bearer.reload
          end.not_to change(bearer, :name)
        end

        include_examples :updates_stock_name

        include_examples :associates_stock_with_bearer
      end

      context 'stock attributes are only present' do
        before do
          params[:stock_attributes] = {
            name: new_stock_name
          }
        end

        it_behaves_like 'operations/success'

        include_examples :updates_stock_name
      end

      context 'bearer attributes are only present' do
        before do
          params[:bearer_attributes] = {
            name: new_bearer_name
          }
        end

        it_behaves_like 'operations/success'

        include_examples :does_not_update_stock_name

        include_examples :creates_new_bearer

        include_examples :associates_stock_with_bearer
      end

      context 'bearer with a given name exists' do
        let(:target_bearer_name) { 'Target Bearer' }
        let!(:target_bearer) { create(:bearer, name: target_bearer_name) }

        before do
          params[:bearer_attributes] = {
            name: target_bearer_name
          }
        end

        it_behaves_like 'operations/success'

        include_examples :does_not_create_bearers

        it 'associates the stock wth a target bearer' do
          expect do
            operation_call
            stock.reload
          end.to change(stock, :bearer).from(bearer).to(target_bearer)
        end
      end

      context 'no attributes present' do
        it_behaves_like 'operations/success'
        include_examples :does_not_create_bearers
        include_examples :does_not_update_stock_name

        it 'does not change association' do
          expect do
            operation_call
            stock.reload
          end.not_to change(stock, :bearer)
        end
      end
    end

    context 'failure' do
      shared_examples :failure do
        it_behaves_like 'operations/failure'

        include_examples :does_not_update_stock_name

        include_examples :does_not_create_bearers
      end

      context 'record not unique' do
        let(:existing_stock_name) { 'Existing Stock' }

        let(:expected_error_messages) do
          ['Stock, Validation failed: Name has already been taken']
        end

        before do
          create(:stock,
                 name: existing_stock_name,
                 bearer: create(:bearer, name: 'Any'))

          params[:stock_attributes] = {
            name: existing_stock_name
          }

          params[:bearer_attributes] = {
            name: new_bearer_name
          }
        end

        include_examples :failure
      end
    end
  end
end
