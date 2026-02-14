require 'rails_helper'

RSpec.describe "Authentication::Users", type: :request do

  let(:valid_params) { { user: { email_address: "newuser@example.com", password: "password123" } } }

  let(:invalid_params) { { user: { email_address: "", password: "123" } } }

  describe "GET /register" do
    it "renders the registration page successfully" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /register" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post users_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "redirects to the onboarding path" do
        post users_path, params: valid_params
        expect(response).to redirect_to(onboardings_path)
      end

      it "signs the user in" do
        post users_path, params: valid_params
        expect(cookies[:session_id]).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post users_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end
end
