module Onboarding::Steps
  def steps
    data.map { Onboarding::Step.new(it) }
  end

  private

  def data
    [
      {
        id: "welcome",
        title: "¡Hola!",
        description: "Te guiaremos en 4 pasos para crear tu tienda online. En 5 minutos estarás compartiendo tu primer link de ventas.",
        fields: [
          {
            name: :welcome,
            type: :welcome
          }
        ]
      },
      {
        id: "store_info",
        title: "Crea tu tienda",
        description: "Comencemos con la información básica",
        fields: [
          {
            name: :name,
            label: "Nombre de tu tienda",
            type: :text_field,
            placeholder: "Mi Tienda Increíble",
            required: true
          },
          {
            name: :industry,
            label: "Que tipo de tienda es?",
            type: :select,
            options: [ "Ropa", "Alimentos", "Servicios", "Otro" ],
            placeholder: "Por ejemplo: Ropa, Alimentos, Servicios, etc.",
            required: true
          }
        ]
      },
      {
        id: "store_color",
        title: "Elige un color",
        description: "Selecciona el color que más te guste",
        fields: [
          {
            name: :primary_color,
            label: "Color principal",
            type: :color_palette,
            options: [
              "#4F46E5", # Indigo
              "#EF4444", # Red
              "#F59E0B", # Amber
              "#10B981", # Emerald
              "#3B82F6", # Blue
              "#8B5CF6", # Violet
              "#EC4899", # Pink
              "#14B8A6", # Teal
              "#F97316", # Orange
              "#6366F1", # Indigo (Lighter)
              "#84CC16", # Lime
              "#06B6D4"  # Cyan
            ],
            required: true
          }
        ]
      },
      {
        id: "product",
        title: "Agrega tu primer producto",
        description: "Comencemos con la información básica",
        fields: [
          {
            name: :product_name,
            label: "Nombre de tu producto",
            type: :text_field,
            placeholder: "Mi Producto Increíble",
            required: true
          },
          {
            name: :price,
            label: "Precio",
            type: :number_field,
            placeholder: "100",
            required: true
          }
        ]
      }
    ]
  end
end
