# frozen_string_literal: true

shared_examples 'contracts/invalid_attribute' do
  it 'looks like failure' do
    expect(validation.call(params)).to be_failure
  end

  it 'has errors' do
    expect(validation.call(params).errors.to_h).to eq(expected_messages)
  end
end
