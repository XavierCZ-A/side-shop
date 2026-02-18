require 'rails_helper'

RSpec.describe "Carts", type: :request do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }

  before { login_as(user) }

  describe "GET /carts/:id" do
    it "renders the cart page successfully" do
      get cart_path(Cart.last)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /carts/:id" do
    it "destroys the cart and redirects" do
      cart = Cart.last
      delete cart_path(cart)

      expect(response).to redirect_to(cart_path(cart))
      follow_redirect!
    end

    it "sets a flash notice" do
      cart = Cart.last
      delete cart_path(cart)

      expect(flash[:notice]).to eq("Tu carrito se vacio")
    end
  end
end
