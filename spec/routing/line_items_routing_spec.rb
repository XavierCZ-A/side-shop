require "rails_helper"

RSpec.describe LineItemsController, type: :routing do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }
  let(:subdomain_host) { "#{store.slug}.lvh.me" }

  describe "routing" do
    it "routes to #create" do
      expect(post: "http://#{subdomain_host}/line_items").to route_to("line_items#create")
    end

    it "routes to #update via PUT" do
      expect(put: "http://#{subdomain_host}/line_items/1").to route_to("line_items#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "http://#{subdomain_host}/line_items/1").to route_to("line_items#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "http://#{subdomain_host}/line_items/1").to route_to("line_items#destroy", id: "1")
    end
  end
end
