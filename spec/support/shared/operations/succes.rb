# frozen_string_literal: true

shared_examples 'operations/success' do
  it 'looks like a success' do
    expect(operation.call).to be_success
  end

  it 'does not have errors' do
    expect(operation.call.errors).to be_empty
  end
end
