# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardInfo::Component, type: :component do
  it "renders the label, value and subtitle" do
    html = render_inline(described_class.new(
      label: "Catálogo",
      value: 6,
      subtitle: "5 activos · 1 borrador"
    ))

    expect(html.to_html).to include("Catálogo")
    expect(html.to_html).to include("6")
    expect(html.to_html).to include("5 activos · 1 borrador")
  end

  it "omits the subtitle paragraph when none is given" do
    html = render_inline(described_class.new(label: "Stock total", value: 33))

    expect(html.css("p").size).to eq(2)
  end

  it "renders one card per element with with_collection" do
    stats = [
      { label: "Catálogo", value: 6, subtitle: "5 activos" },
      { label: "Sin stock", value: 1, variant: :danger }
    ]

    html = render_inline(described_class.with_collection(stats))

    expect(html.css("div.rounded-2xl").size).to eq(2)
    expect(html.to_html).to include("Catálogo")
    expect(html.to_html).to include("Sin stock")
    expect(html.css("p")[4][:class]).to include("text-red-600")
  end

  it "colors the value according to the variant" do
    success = render_inline(described_class.new(label: "Stock", value: 33, variant: :success))
    danger  = render_inline(described_class.new(label: "Sin stock", value: 1, variant: :danger))

    expect(success.css("p")[1][:class]).to include("text-green-700")
    expect(danger.css("p")[1][:class]).to include("text-red-600")
  end
end
