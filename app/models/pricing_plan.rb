class PricingPlan
  ALL = [
    {
      name: "Basico",
      label: "Basic",
      price_id: "price_1RBKSLRezILKw9BZITdngjFT",
      amount: "Gratis",
      features: [
        "Hasta 5 productos",
        "Link compartible",
        "Pedidos por WhatsApp / manuales",
        "Sin pasarela de pago",
      ]
    },
    {
      name: "negocio",
      label: "Pro",
      price_id: "price_1TIOQqRezILKw9BZeGU0stt7",
      amount: "$99 / mes",
      features: [
        "Hasta 100 productos",
        "Conecta tus pasarelas(Stripe, MercadoPago, PayPal, OXXO…)",
        "Cobro online automático",
        "Link compartible",
        "Notificaciones de pedido por WhatsApp / email",
        "Historial de ventas"
      ]
    }
  ].freeze

  def self.all
    ALL
  end

  def self.find(plan_name)
    ALL.find { |plan| plan[:name] == plan_name.to_s }
  end
end