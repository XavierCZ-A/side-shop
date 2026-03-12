require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/store/store_example/carts").to route_to("carts#show", store_slug: "store_example")
    end

    it "routes to #destroy" do
      expect(delete: "/store/store_example/carts").to route_to("carts#destroy", store_slug: "store_example")
    end
  end
end
