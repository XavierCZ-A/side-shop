require 'rails_helper'

RSpec.describe "Admin::Subscriptions", type: :request do
  let(:user) { create(:user) }
  let!(:store) { create(:store, user: user) }

  before do
    user.set_payment_processor :fake_processor, allow_fake: true
    login_as(user) 
  end

  describe "POST susbcription" do
    it "redirect to checkout" do
      post admin_subscriptions_path, params: { plan: "fake" }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "CANCEL susbcription" do
    it "redirect to billing" do
      subscription = user.payment_processor.subscribe(plan: "fake", ends_at: 1.week.ago)
      delete admin_subscription_path(subscription)

      expect(subscription.reload.canceled?).to be true
      expect(response).to redirect_to(admin_billing_url)
    end
  end

  describe "RESUME susbcription" do
    it "redirect to billing" do
      subscription = user.payment_processor.subscribe(plan: "fake", ends_at: 1.week.ago)
      subscription.cancel

      patch resume_admin_subscription_path(subscription)

      expect(subscription.reload.on_grace_period?).to be false
      expect(response).to redirect_to(admin_billing_url)
    end
  end
end