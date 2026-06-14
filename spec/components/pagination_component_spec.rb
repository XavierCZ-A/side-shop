# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pagination::Component, type: :component do
  def pagy_double(overrides = {})
    data = {
      url_template: "/dashboard/products?page=#{Pagy::PAGE_TOKEN}",
      previous_url: "/dashboard/products?page=1",
      next_url: "/dashboard/products?page=3",
      from: 7,
      to: 12,
      count: 36,
      last: 6,
      series: [ 1, :gap, 2, "2", 3, :gap, 6 ]
    }.merge(overrides)

    instance_double(Pagy, data_hash: data)
  end

  it "does not render when there is a single page" do
    html = render_inline(described_class.new(pagy: pagy_double(last: 1)))

    expect(html.to_html).to be_blank
  end

  it "renders the record range and page links" do
    html = render_inline(described_class.new(pagy: pagy_double))

    expect(html.to_html).to include("7–12 de 36")
    expect(html.css("a[href='/dashboard/products?page=3']")).to be_present
    expect(html.css("span[aria-current='page']").text).to eq("2")
    expect(html.to_html).to include("…")
  end

  it "renders disabled previous control on the first page" do
    html = render_inline(described_class.new(pagy: pagy_double(previous_url: nil)))

    expect(html.css("a[rel='prev']")).to be_empty
    expect(html.css("span[aria-hidden='true']")).to be_present
  end
end
