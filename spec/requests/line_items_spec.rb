require 'rails_helper'

RSpec.describe "LineItems", type: :request do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }
  let(:product) { create(:product, store: store, price: 20.00) }

  before { login_as(user) }

  describe "POST /line_items" do
    it "adds a product to the cart" do
      expect {
        post line_items_path, params: { product_id: product.id }
      }.to change(LineItem, :count).by(1)
    end

    it "redirects on html format" do
      post line_items_path, params: { product_id: product.id }
      expect(response).to redirect_to(admin_root_path)
    end

    context "when product is already in cart" do
      before { post line_items_path, params: { product_id: product.id } }

      it "increments quantity instead of creating a new line item" do
        expect {
          post line_items_path, params: { product_id: product.id }
        }.not_to change(LineItem, :count)

        expect(LineItem.last.quantity).to eq(2)
      end
    end
  end

  describe "PATCH /line_items/:id" do
    let!(:line_item) do
      post line_items_path, params: { product_id: product.id }
      LineItem.last
    end

    context "with increment operation" do
      it "increments the quantity" do
        patch line_item_path(line_item), params: { operation: "increment" }
        expect(line_item.reload.quantity).to eq(2)
      end
    end

    context "with decrement operation" do
      before do
        line_item.update!(quantity: 3)
      end

      it "decrements the quantity" do
        patch line_item_path(line_item), params: { operation: "decrement" }
        expect(line_item.reload.quantity).to eq(2)
      end
    end

    context "with decrement when quantity is 1" do
      it "does not decrement below 1" do
        patch line_item_path(line_item), params: { operation: "decrement" }
        expect(line_item.reload.quantity).to eq(1)
      end
    end

    it "redirects on html format" do
      patch line_item_path(line_item), params: { operation: "increment" }
      expect(response).to redirect_to(cart_path(Cart.last))
    end
  end

  describe "DELETE /line_items/:id" do
    let!(:line_item) do
      post line_items_path, params: { product_id: product.id }
      LineItem.last
    end

    it "removes the line item" do
      expect {
        delete line_item_path(line_item)
      }.to change(LineItem, :count).by(-1)
    end

    it "redirects to cart" do
      delete line_item_path(line_item)
      expect(response).to redirect_to(cart_path(Cart.last))
    end
  end
end
