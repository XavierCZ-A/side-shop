class PricingPlan
  ALL = [
    {
      name: "Basico",
      label: "Perfecto para probar tu idea sin riesgos.",
      price_id: "price_1RBKSLRezILKw9BZITdngjFT",
      amount: "Gratis",
      features: [
        { label: "Hasta 5 productos",             included: true  },
        { label: "Link compartible",              included: true  },
        { label: "Pedidos por WhatsApp",          included: true  },
        { label: "Pasarelas de pago",             included: false },
        { label: "Generacion de cupones",         included: false },
        { label: "Estadísticas de visitas",       included: false },
        { label: "Historial de ventas",           included: false }
      ]
    },
    {
      name: "Negocio",
      label: "Tu marca al siguiente nivel.",
      price_id: "price_1TIOQqRezILKw9BZeGU0stt7",
      amount: "$99 / mes",
      features: [
        { label: "Productos ilimitados",          included: true },
        { label: "Link compartible",              included: true },
        { label: "Pedidos por WhatsApp",          included: true },
        { label: "Pasarelas de pago",             included: true },
        { label: "Generacion de cupones",         included: true },
        { label: "Estadísticas de visitas",       included: true },
        { label: "Historial de ventas",           included: true }
      ]
    }
  ].freeze

  def self.all
    ALL
  end
  def self.find(name)
    ALL.find { |p| p[:name] == name.to_s }
  end
end
