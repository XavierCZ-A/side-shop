# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Associations" do
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe "#add_product" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }

    context "when product is not in cart" do
      it "builds a new line item with quantity 1" do
        line_item = cart.add_product(product)
        expect(line_item).to be_a(LineItem)
        expect(line_item.quantity).to eq(1)
        expect(line_item.product).to eq(product)
      end
    end

    context "when product is already in cart" do
      before { create(:line_item, cart: cart, product: product, quantity: 1) }

      it "increments quantity of existing line item" do
        line_item = cart.add_product(product)
        expect(line_item.quantity).to eq(2)
      end

      it "does not create a new line item" do
        expect { cart.add_product(product) }.not_to change(LineItem, :count)
      end
    end
  end

  describe "#total_price" do
    let(:cart) { create(:cart) }
    let(:product1) { create(:product, price: 10.00) }
    let(:product2) { create(:product, price: 25.50) }

    it "returns sum of all line item prices" do
      create(:line_item, cart: cart, product: product1, quantity: 2)
      create(:line_item, cart: cart, product: product2, quantity: 1)

      expect(cart.total_price).to eq(45.50)
    end

    it "returns 0 for empty cart" do
      expect(cart.total_price).to eq(0)
    end
  end
end
