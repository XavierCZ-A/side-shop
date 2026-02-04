require 'rails_helper'

RSpec.describe "stores/index", type: :view do
  before(:each) do
    assign(:stores, [
      Store.create!(
        name: "Name",
        slug: "Slug",
        description: "MyText",
        active: false,
        primary_color: "Primary Color",
        whatsapp: "Whatsapp",
        instagram: "Instagram",
        facebook: "Facebook"
      ),
      Store.create!(
        name: "Name",
        slug: "Slug",
        description: "MyText",
        active: false,
        primary_color: "Primary Color",
        whatsapp: "Whatsapp",
        instagram: "Instagram",
        facebook: "Facebook"
      )
    ])
  end

  it "renders a list of stores" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Slug".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Primary Color".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Whatsapp".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Instagram".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Facebook".to_s), count: 2
  end
end
