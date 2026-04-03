require 'rails_helper'

RSpec.describe "Carts", type: :request do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }
  let(:subdomain_host) { "#{store.slug}.lvh.me" }

  before do
    login_as(user)
    host! subdomain_host
  end

  describe "GET /carts" do
    it "renders the cart page successfully" do
      get cart_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /carts" do
    it "destroys the cart and redirects" do
      delete cart_path

      expect(response).to redirect_to(store_root_path)
      follow_redirect! 
    end

    it "sets a flash notice" do
      delete cart_path

      expect(flash[:notice]).to eq("Tu carrito se vació")
    end
  end
end
