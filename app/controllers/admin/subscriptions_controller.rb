class Admin::SubscriptionsController < ApplicationController
  rescue_from Pay::Error, with: :handle_payment_error

  def new
    @plans = PricingPlan.all
  end

  def create
    plan = PricingPlan.find(params[:plan])
    return redirect_to new_admin_subscription_path, alert: "Plan inválido" unless plan

    checkout = current_user.payment_processor.checkout(
      mode:       "subscription",
      line_items: plan[:price_id],
      success_url: admin_billing_url + "?success=true",
      cancel_url:  new_admin_subscription_url,
      subscription_data: {
        metadata: {
          pay_name: plan[:name]
        }
      }
    )

    redirect_to checkout.url, allow_other_host: true

  rescue Stripe::AuthenticationError => e
    logger.error "Error de autenticación con Stripe: #{e.message}"
    redirect_to admin_billing_url, alert: "Ocurrió un error al procesar tu pago. Por favor, intenta nuevamente o contacta soporte."
  end

  def destroy
    subscription = processor_subscription

    if subscription
      subscription.cancel
      redirect_to admin_billing_url, notice: "Suscripción cancelada al final del periodo."
    else
      redirect_to admin_billing_url, alert: "No se encontró una suscripción activa."
    end
  end

  def resume
    subscription = processor_subscription

    if subscription&.on_grace_period?
      subscription.resume
      redirect_to admin_billing_url, notice: "¡Tu suscripción ha sido reactivada con éxito!"
    else
      redirect_to admin_billing_url, alert: "No se puede reactivar esta suscripción."
    end
  end

  private

  def handle_payment_error(exception)
    logger.error "Error de pago: #{exception.message}"
    redirect_to admin_billing_url, alert: "Ocurrió un error al procesar tu pago. Por favor, intenta nuevamente o contacta soporte."
  end

  def processor_subscription
  current_user.payment_processor
              &.subscriptions
              &.order(created_at: :desc)
              &.first
  end
end
