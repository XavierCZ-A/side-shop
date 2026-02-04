require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:store) { create(:store) }
  let(:product) { create(:product, store: store) }

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }

    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe "Associations" do
    it { should belong_to(:store) }
  end
end
