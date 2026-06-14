# frozen_string_literal: true

require "rails_helper"

RSpec.describe Table::Component, type: :component do
  it "does not render when there are no products" do
    expect(render_inline(described_class.new(products: [])).to_html).to be_blank
  end

  it "renders a row per product with name, price, stock and status" do
    product = create(:product, :with_images, name: "Tazón ondas", price: 480, stock: 7, active: true)

    html = render_inline(described_class.new(products: [ product ]))

    headers = html.css("thead th").map(&:text).map(&:strip)
    expect(headers).to include("Producto", "Estatus")
    expect(headers.any? { |h| h.start_with?("Precio") }).to be(true)
    expect(headers.any? { |h| h.start_with?("Stock") }).to be(true)
    expect(html.to_html).to include("Tazón ondas")
    expect(html.css("tbody tr").size).to eq(1)
    expect(html.to_html).to include("Activo")
  end

  it "shows the draft status for inactive products" do
    product = create(:product, :with_images, name: "Jarra leche", price: 520, active: false)

    html = render_inline(described_class.new(products: [ product ]))

    expect(html.to_html).to include("Borrador")
  end
end
