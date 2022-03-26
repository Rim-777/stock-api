# frozen_string_literal: true

shared_examples 'contracts/valid_attributes' do
  it 'looks like success' do
    expect(validation.call(params)).to be_success
  end

  it 'returns correct params' do
    expect(validation.call(params).to_h).to eq params
  end

  it 'has no errors' do
    expect(validation.call(params).errors).to be_empty
  end
end
