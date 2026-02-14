require 'rails_helper'

RSpec.describe Onboarding, type: :model do
  let(:user) { create(:user) }
  let(:onboarding) { Onboarding.new(valid_params) }

  let(:valid_params) do
    {
      name: "My Awesome Store",
      industry: "Tecnología",
      primary_color: "#FF5733",
      product_name: "Super Gadget",
      price: 99.99,
      current_user: user
    }
  end

  describe "Validations" do
    it { should validate_presence_of(:name).with_message("El nombre de la tienda es requerido") }
    it { should validate_presence_of(:industry).with_message("Selecciona una industria") }
    it { should validate_presence_of(:primary_color).with_message("Selecciona un color") }
    it { should validate_presence_of(:product_name).with_message("El nombre del producto es requerido") }
    it { should validate_presence_of(:price).with_message("El precio es requerido") }
    it { should validate_numericality_of(:price).is_greater_than(0).with_message("El precio debe ser mayor a 0") }

    context "when industry is 'Otro'" do
      before { allow(subject).to receive(:industry).and_return("Otro") }
      it { should validate_presence_of(:other_industry).with_message("Especifica tu industria") }
    end
  end

  describe "#save" do
    it "creates a store for the user" do
      expect {
        onboarding.save
      }.to change(Store, :count).by(1)
      
      store = Store.last
      expect(store.user).to eq(user)
      expect(store.name).to eq("My Awesome Store")
      expect(store.industry).to eq("Tecnología")
      expect(store.primary_color).to eq("#FF5733")
      expect(store.onboarding_complete).to be(true)
    end

    it "creates a product for the store" do
      expect {
        onboarding.save
      }.to change(Product, :count).by(1)

      product = Product.last
      expect(product.store).to eq(Store.last)
      expect(product.name).to eq("Super Gadget")
      expect(product.price).to eq(99.99)
    end

    context "when save fails" do
      before do
        allow(user).to receive(:create_store!).and_raise(ActiveRecord::RecordInvalid.new(Store.new))
      end

      it "returns false and adds errors" do
        expect(onboarding.save).to be(false)
        expect(onboarding.errors[:base]).to be_present
      end
    end
  end

  describe "#generate_slug" do
    it "generates a slug from the store name" do
      onboarding.name = "My Awesome Store"
      onboarding.save
      expect(Store.last.slug).to eq("my-awesome-store")
    end
    
    it "handles duplicate slugs" do
      create(:store, slug: "my-awesome-store")
      onboarding.name = "My Awesome Store"
      onboarding.save
      expect(Store.last.slug).to eq("my-awesome-store-1")
    end
  end
end
