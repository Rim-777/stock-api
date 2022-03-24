require 'rails_helper'

RSpec.describe Stock, type: :model do
  it { should belong_to(:bearer).inverse_of(:stocks) }

  describe 'validations' do
    let(:subject) {build(:stock, name: 'Stock' )}
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
