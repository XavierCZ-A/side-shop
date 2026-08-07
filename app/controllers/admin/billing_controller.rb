class Admin::BillingController < ApplicationController
  def portal
    portal_session = current_user.payment_processor.billing_portal(
      return_url: admin_settings_url
    )
    redirect_to portal_session.url, allow_other_host: true

  rescue Stripe::AuthenticationError => e
    logger.error "Error al crear sesión del portal de facturación: #{e.message}"
    redirect_to admin_billing_url, alert: "Ocurrió un error al acceder al portal de facturación. Por favor, intenta nuevamente."
  end
end
