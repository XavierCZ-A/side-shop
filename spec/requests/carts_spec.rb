require 'rails_helper'

RSpec.describe "Carts", type: :request do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }

  before { login_as(user) }

  describe "GET store/:store_slug/carts/" do
    it "renders the cart page successfully" do
      cart = Cart.last
      get carts_path(store.slug, cart)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE store/:store_slug/carts/" do
    it "destroys the cart and redirects" do
      cart = Cart.last
      delete carts_path(store.slug, cart)

      expect(response).to redirect_to(store_path(store.slug))
      follow_redirect! 
    end

    it "sets a flash notice" do
      cart = Cart.last
      delete carts_path(store.slug, cart)

      expect(flash[:notice]).to eq("Tu carrito se vació")
    end
  end
end
