require 'rails_helper'

RSpec.describe "LineItems routing", type: :routing do
  it "routes POST /line_items to line_items#create" do
    expect(post: "/line_items").to route_to("line_items#create")
  end

  it "routes PATCH /line_items/:id to line_items#update" do
    expect(patch: "/line_items/1").to route_to("line_items#update", id: "1")
  end

  it "routes DELETE /line_items/:id to line_items#destroy" do
    expect(delete: "/line_items/1").to route_to("line_items#destroy", id: "1")
  end

  it "does not route GET /line_items" do
    expect(get: "/line_items").not_to be_routable
  end

  it "does not route GET /line_items/:id" do
    expect(get: "/line_items/1").not_to be_routable
  end
end
