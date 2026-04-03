require "rails_helper"

RSpec.describe CartsController, type: :routing do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }
  let(:subdomain_host) { "#{store.slug}.lvh.me" }

  describe "routing" do
    it "routes to #show" do
      expect(get: "http://#{subdomain_host}/cart").to route_to("carts#show")
    end

    it "routes to #destroy" do
      expect(delete: "http://#{subdomain_host}/cart").to route_to("carts#destroy")
    end
  end
end
