require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:store) { create(:store) }
  let(:product) { create(:product) }

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:images) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe "Associations" do
    it { should belong_to(:store) }
    it { should have_many(:line_items).dependent(:destroy) }
    it { should have_many(:order_items) }
    it { should have_many_attached(:images).dependent(:destroy) }
  end

  describe ".active" do
    it "returns only active products" do
      active_product = create(:product, :with_images, active: true)
      inactive_product = create(:product, :with_images, active: false)

      expect(Product.active).to include(active_product)
      expect(Product.active).not_to include(inactive_product)
    end    
  end

  describe ".inactive" do
    it "returns only inactive products" do
      active_product = create(:product, :with_images, active: true)
      inactive_product = create(:product, :with_images, active: false)

      expect(Product.inactive).to include(inactive_product)
      expect(Product.inactive).not_to include(active_product)
    end    
  end
end
