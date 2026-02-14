require "rails_helper"

RSpec.describe Admin::DashboardsController, type: :routing do
  describe "routing" do
    it "routes to #edit" do
      expect(get: "/dashboard/customize").to route_to("admin/dashboards#edit")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dashboard/customize").to route_to("admin/dashboards#update")
    end
  end
end
