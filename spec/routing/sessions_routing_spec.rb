require "rails_helper"

RSpec.describe Authentication::SessionsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/login").to route_to("authentication/sessions#new")
    end

    it "routes to #create" do
      expect(post: "/login").to route_to("authentication/sessions#create")
    end

    it "routes to #destroy" do
      expect(delete: "/login").to route_to("authentication/sessions#destroy")
    end
  end
end
