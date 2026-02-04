require 'rails_helper'

RSpec.describe "stores/edit", type: :view do
  let(:store) {
    Store.create!(
      name: "MyString",
      slug: "MyString",
      description: "MyText",
      active: false,
      primary_color: "MyString",
      whatsapp: "MyString",
      instagram: "MyString",
      facebook: "MyString"
    )
  }

  before(:each) do
    assign(:store, store)
  end

  it "renders the edit store form" do
    render

    assert_select "form[action=?][method=?]", store_path(store), "post" do

      assert_select "input[name=?]", "store[name]"

      assert_select "input[name=?]", "store[slug]"

      assert_select "textarea[name=?]", "store[description]"

      assert_select "input[name=?]", "store[active]"

      assert_select "input[name=?]", "store[primary_color]"

      assert_select "input[name=?]", "store[whatsapp]"

      assert_select "input[name=?]", "store[instagram]"

      assert_select "input[name=?]", "store[facebook]"
    end
  end
end
