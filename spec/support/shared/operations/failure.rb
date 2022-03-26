# frozen_string_literal: true

shared_examples 'operations/failure' do
  it 'looks like failure' do
    expect(operation.call).to be_failure
  end

  it 'contains errors' do
    expect(operation.call.errors).to eq(expected_error_message)
  end
end
