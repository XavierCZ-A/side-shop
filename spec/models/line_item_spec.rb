require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe "Associations" do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
  end

  describe "#total_price" do
    let(:product) { create(:product, price: 15.00) }
    let(:line_item) { create(:line_item, product: product, quantity: 3) }

    it "returns price * quantity" do
      expect(line_item.total_price).to eq(45.00)
    end

    it "returns product price when quantity is 1" do
      line_item.quantity = 1
      expect(line_item.total_price).to eq(15.00)
    end
  end
end
