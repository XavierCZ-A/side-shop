require "rails_helper"

RSpec.describe Authentication::UsersController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/register").to route_to("authentication/users#new")
    end

    it "routes to #create" do
      expect(post: "/register").to route_to("authentication/users#create")
    end
  end
end
