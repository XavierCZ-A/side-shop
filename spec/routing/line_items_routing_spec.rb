require "rails_helper"

RSpec.describe LineItemsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/store/store_example/line_items").to route_to("line_items#create", store_slug: "store_example")
    end

    it "routes to #update via PUT" do
      expect(put: "/store/store_example/line_items/1").to route_to("line_items#update", store_slug: "store_example", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/store/store_example/line_items/1").to route_to("line_items#update", store_slug: "store_example", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/store/store_example/line_items/1").to route_to("line_items#destroy", store_slug: "store_example", id: "1")
    end
  end
end
