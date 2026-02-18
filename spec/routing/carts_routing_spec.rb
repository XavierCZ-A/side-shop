require 'rails_helper'

RSpec.describe "Carts routing", type: :routing do
  it "routes GET /carts/:id to carts#show" do
    expect(get: "/carts/1").to route_to("carts#show", id: "1")
  end

  it "routes DELETE /carts/:id to carts#destroy" do
    expect(delete: "/carts/1").to route_to("carts#destroy", id: "1")
  end

  it "does not route POST /carts" do
    expect(post: "/carts").not_to be_routable
  end
end
