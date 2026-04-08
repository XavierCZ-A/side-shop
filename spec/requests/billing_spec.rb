# spec/requests/admin/billing_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Billing", type: :request do
  let(:user) { create(:user) }
  let!(:store) { create(:store, user: user) }

  before do
    user.set_payment_processor :fake_processor, allow_fake: true
    login_as(user) 
  end

  describe "GET /show" do
    it "show billing page" do
      get admin_billing_path
      expect(response).to have_http_status(:success)
    end

    it "show current plan" do
      user.payment_processor.subscribe(plan: "fake", ends_at: 1.week.ago)
      get admin_billing_path, params: { success: true }

      expect(flash[:notice]).to eq("¡Suscripción activada! Bienvenido.")
    end
  end
end