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
  ASPECT_RATIOS = %w[1:1 4:5].freeze

  has_one_attached :image

  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy

  store_accessor :design_config, :vibe, :hero_layout, :border_radius,
                                 :aspect_ratio, :grain_enabled

  validates :vibe,         inclusion: { in: VIBES },         allow_blank: true
  validates :hero_layout,  inclusion: { in: HERO_LAYOUTS },  allow_blank: true
  validates :aspect_ratio, inclusion: { in: ASPECT_RATIOS }, allow_blank: true
  validate  :border_radius_within_allowed

  def vibe          = (super.presence || "editorial")
  def hero_layout   = (super.presence || "centered")
  def border_radius = (super.presence || 8).to_i
  def aspect_ratio  = (super.presence || "1:1")
  def grain_enabled = ActiveModel::Type::Boolean.new.cast(super) || false

  private

  def border_radius_within_allowed
    return if design_config["border_radius"].blank?
    return if BORDER_RADII.include?(design_config["border_radius"].to_i)

    errors.add(:border_radius, :inclusion)
  end
end
