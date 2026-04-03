require "rails_helper"

RSpec.describe StoresController, type: :routing do
  let(:user) { create(:user, password: "password") }
  let!(:store) { create(:store, user: user) }
  let(:subdomain_host) { "#{store.slug}.lvh.me" }

  describe "routing" do
    it "routes subdomain root to stores#show" do
      expect(get: "http://#{subdomain_host}/").to route_to("stores#show")
    end
  end
end
