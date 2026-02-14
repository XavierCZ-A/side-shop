require 'rails_helper'

RSpec.describe "Authentication::Sessions", type: :request do
  let(:user) { create(:user, password: "password") }

  let(:valid_credentials) { { email_address: user.email_address, password: "password" } }

  let(:invalid_credentials) { { email_address: user.email_address, password: "wrong_password" } }

  describe "GET /login" do
    it "renders the login page successfully" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "creates a session and redirects to root" do
        expect {
          post session_path, params: valid_credentials
        }.to change(Session, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(cookies[:session_id]).to be_present
      end
    end

    context "with invalid credentials" do
      it "does not create a session and redirects to login with an alert" do
        expect {
          post session_path, params: invalid_credentials
        }.not_to change(Session, :count)

        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq("La contraseña o el correo electrónico es incorrecto.")
      end
    end
  end

  describe "DELETE /logout" do
    before do
      post session_path, params: valid_credentials
    end

    it "destroys the session and redirects to login" do
      expect {
        delete session_path
      }.to change(Session, :count).by(-1)

      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_blank
    end
  end
end
