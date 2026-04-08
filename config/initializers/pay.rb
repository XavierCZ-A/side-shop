Pay.setup do |config|
  config.business_name = "Side Shopy"
  config.support_email = "soporte@tuapp.com"

  # Emails automáticos
  config.emails.payment_failed        = true
  config.emails.receipt               = true
  config.emails.subscription_renewing = true
  config.emails.refund                = true
end