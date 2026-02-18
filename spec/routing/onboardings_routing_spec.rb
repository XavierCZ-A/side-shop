require 'rails_helper'

RSpec.describe "Onboardings routing", type: :routing do
  it "routes GET /get-started to onboardings#show" do
    expect(get: "/get-started").to route_to("onboardings#show")
  end

  it "routes POST /get-started to onboardings#create" do
    expect(post: "/get-started").to route_to("onboardings#create")
  end

  it "does not route DELETE /get-started" do
    expect(delete: "/get-started").not_to be_routable
  end
end
