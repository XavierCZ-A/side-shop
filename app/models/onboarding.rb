class Onboarding
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Onboarding::Steps

  # Store attributes
  attribute :name, :string
  attribute :industry, :string
  attribute :other_industry, :string
  attribute :primary_color, :string

  # Product attributes
  attribute :product_name, :string
  attribute :price, :decimal

  # Validations
  validates :name, presence: { message: "El nombre de la tienda es requerido" }
  validates :industry, presence: { message: "Selecciona una industria" }
  validates :primary_color, presence: { message: "Selecciona un color" }
  validates :product_name, presence: { message: "El nombre del producto es requerido" }
  validates :price, presence: { message: "El precio es requerido" },
                    numericality: { greater_than: 0, message: "El precio debe ser mayor a 0" }

  validates :other_industry, presence: { message: "Especifica tu industria" }, if: :other_industry_required?

  attr_accessor :current_user

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      store = create_store
      create_product(store)
      store
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def model_name = ActiveModel::Name.new(self, nil, "Onboarding")

  def resolved_industry
    industry == "Otro" ? other_industry : industry
  end

  private

  def other_industry_required?
    industry == "Otro"
  end

  def create_store
    current_user.create_store!(
      name: name,
      slug: generate_slug,
      industry: resolved_industry,
      primary_color: primary_color,
      onboarding_complete: true
    )
  end

  def create_product(store)
    store.products.create!(
      name: product_name,
      price: price,
    )
  end

  def generate_slug
    base_slug = name.to_s
                    .downcase
                    .strip
                    .gsub(/[áàäâã]/, "a")
                    .gsub(/[éèëê]/, "e")
                    .gsub(/[íìïî]/, "i")
                    .gsub(/[óòöôõ]/, "o")
                    .gsub(/[úùüû]/, "u")
                    .gsub(/ñ/, "n")
                    .gsub(/\s+/, "-")
                    .gsub(/[^\w\-]/, "")
                    .gsub(/\-\-+/, "-")

    slug = base_slug
    counter = 1

    while Store.exists?(slug: slug)
      slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    slug
  end
end
