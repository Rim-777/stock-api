# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stocks::Index do
  let(:operation) { described_class.new }

  describe '#call' do
    let!(:bearer) { create(:bearer, name: 'Bearer') }

    before do
      create_list(:stock, 10, :sequence_stock_name, bearer: bearer)
      operation.call
    end

    it 'returns expected number of records' do
      expect(operation.result.count).to eq(10)
    end

    it 'returns an instance of an expected class' do
      expect(operation.result).to be_a(ActiveRecord::Relation)
    end

    it 'returns instances of an expected class' do
      operation.result.each do |stock|
        expect(stock).to be_a(Stock)
      end
    end
  end
end
