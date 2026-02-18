require 'rails_helper'

RSpec.describe "Onboardings", type: :request do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  describe "GET /get-started" do
    it "renders the onboarding page successfully" do
      get onboardings_path
      expect(response).to have_http_status(:success)
    end

    context "when user has already completed onboarding" do
      before do
        create(:store, user: user, onboarding_complete: true)
      end

      it "redirects to root path" do
        get onboardings_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /get-started" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          onboarding: {
            name: "My Awesome Store",
            industry: "Tecnología",
            primary_color: "#FF5733",
            product_name: "Super Gadget",
            price: 99.99
          }
        }
      end

      it "creates a store and product" do
        expect {
          post onboardings_path, params: valid_params
        }.to change(Store, :count).by(1)
         .and change(Product, :count).by(1)
      end

      it "redirects to root path with a success message" do
        post onboardings_path, params: valid_params
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("¡Tienda creada exitosamente! 🎉")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          onboarding: {
            name: "",
            industry: "",
            primary_color: "",
            product_name: "",
            price: nil
          }
        }
      end

      it "does not create a store or product" do
        expect {
          post onboardings_path, params: invalid_params
        }.not_to change(Store, :count)
        
        expect(Product.count).to eq(0)
      end

      it "renders the show template with unprocessable entity status" do
        post onboardings_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user has already completed onboarding" do
       before do
        create(:store, user: user, onboarding_complete: true)
      end

      it "redirects to root path" do
        post onboardings_path, params: { onboarding: { name: "New Store" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
