# == Schema Information
#
# Table name: stores
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  slug                :string           not null
#  description         :text
#  active              :boolean          default(TRUE), not null
#  primary_color       :string
#  whatsapp            :string
#  instagram           :string
#  facebook            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer          not null
#  industry            :string
#  onboarding_complete :boolean          default(FALSE), not null
#
# Indexes
#
#  index_stores_on_user_id  (user_id)
#

class Store < ApplicationRecord
  VIBES         = %w[editorial organic modern].freeze
  HERO_LAYOUTS  = %w[centered split banner].freeze
  BORDER_RADII  = [ 0, 8, 24 ].freeze

  before_validation :generate_slug, on: :create

  has_one_attached :image

  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy

  store_accessor :design_config, :vibe, :hero_layout, :border_radius

  validates :vibe,         inclusion: { in: VIBES },         allow_blank: true
  validates :hero_layout,  inclusion: { in: HERO_LAYOUTS },  allow_blank: true
  validate  :border_radius_within_allowed

  def vibe          = (super.presence || "editorial")
  def hero_layout   = (super.presence || "centered")
  def border_radius = (super.presence || 8).to_i

  private

  def border_radius_within_allowed
    return if design_config["border_radius"].blank?
    return if BORDER_RADII.include?(design_config["border_radius"].to_i)

    errors.add(:border_radius, :inclusion)
  end

  def generate_slug
    return if slug.present?
    return if name.blank?

    base_slug = slugify(name)
    candidate = base_slug
    counter = 2

    while Store.exists?(slug: candidate)
      candidate = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = candidate
  end

  def slugify(text)
    text.to_s
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
  end
end
