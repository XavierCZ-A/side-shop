require 'rails_helper'

RSpec.describe "stores/show", type: :view do
  before(:each) do
    assign(:store, Store.create!(
      name: "Name",
      slug: "Slug",
      description: "MyText",
      active: false,
      primary_color: "Primary Color",
      whatsapp: "Whatsapp",
      instagram: "Instagram",
      facebook: "Facebook"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Primary Color/)
    expect(rendered).to match(/Whatsapp/)
    expect(rendered).to match(/Instagram/)
    expect(rendered).to match(/Facebook/)
  end
end
