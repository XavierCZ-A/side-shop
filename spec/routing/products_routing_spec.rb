require "rails_helper"

RSpec.describe Admin::ProductsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/dashboard/products/new").to route_to("admin/products#new")
    end

    it "routes to #edit" do
      expect(get: "/dashboard/products/1/edit").to route_to("admin/products#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/dashboard/products").to route_to("admin/products#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/dashboard/products/1").to route_to("admin/products#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dashboard/products/1").to route_to("admin/products#update", id: "1")
    end

  end
end
