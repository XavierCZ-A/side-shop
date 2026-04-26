# config/initializers/stripe.rb
Rails.application.config.after_initialize do
  Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
end
