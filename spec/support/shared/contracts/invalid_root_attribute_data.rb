# frozen_string_literal: true

shared_examples 'contracts/invalid_root_attribute_data' do
  let(:key) { :data }

  context 'missing key' do
    before do
      params.delete(key)
    end

    let(:expected_messages) do
      { key => ['is missing'] }
    end

    it_behaves_like 'contracts/invalid_attribute'
  end

  context 'invalid type' do
    before do
      params[key] = []
    end

    let(:expected_messages) do
      { key => ['must be a hash'] }
    end

    it_behaves_like 'contracts/invalid_attribute'
  end

  context 'empty' do
    before do
      params[key] = {}
    end

    it_behaves_like 'contracts/invalid_attribute'
  end
end
