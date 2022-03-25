require 'rails_helper'

RSpec.describe Bearer, type: :model do
  it { should have_many(:stocks).inverse_of(:bearer).dependent(:destroy) }

  describe 'validations' do
    let(:subject) { build(:bearer, name: 'Bearer') }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
