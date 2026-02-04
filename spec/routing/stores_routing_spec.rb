require "rails_helper"

RSpec.describe StoresController, type: :routing do
  describe "GET /store/:store_slug" do
    it "routes to stores#show with the correct slug" do
      expect(get: "/store/mi-tienda-increible").to route_to(
        controller: "stores",
        action: "show",
        store_slug: "mi-tienda-increible"
      )
    end

    it "generates the 'store_path' helper route" do
      # Esto verifica que el 'as: :store' funcione correctamente
      expect(get: store_path("mi-tienda")).to route_to(
        controller: "stores",
        action: "show",
        store_slug: "mi-tienda"
      )
    end
  end
end
