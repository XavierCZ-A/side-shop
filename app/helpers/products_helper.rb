module ProductsHelper
  # Stats shown in the CardInfo grid on the products index.
  def product_stats(products)
    active_count = products.count_active
    inactive_count = products.count_inactive
    total_stock = products.sum(&:stock)
    out_of_stock = products.count { |p| p.stock.zero? }

    [
      { label: "Catálogo", value: products.size, subtitle: "#{active_count} Activos · #{inactive_count} Desactivados" },
      { label: "Stock total", value: total_stock, subtitle: "Disponibles", variant: :success },
      { label: "Sin stock", value: out_of_stock, subtitle: "Actualiza el stock", variant: :danger },
      { label: "Vendidos · 7d", value: 36, subtitle: "", variant: :success }
    ]
  end
end
