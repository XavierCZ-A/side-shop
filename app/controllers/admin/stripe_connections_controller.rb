class Admin::StripeConnectionsController < ApplicationController
  def create
    store = current_user.store

    if store.stripe_account_id.blank?
      account = Stripe::Account.create(
        type: "standard",
        country: "MX",
        email: store.user.email,
        business_type: "individual",
        capabilities: {
          card_payments: { requested: true },
          transfers:     { requested: true }
        },
        metadata: { store_id: store.id }
      )
      store.update!(stripe_account_id: account.id)
    end

    link = Stripe::AccountLink.create(
      account:     store.stripe_account_id,
      refresh_url: admin_stripe_connection_url,
      return_url:  admin_settings_url,
      type:        "account_onboarding"
    )

    redirect_to link.url, allow_other_host: true
  end
end
