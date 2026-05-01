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
  has_one_attached :image

  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy
end
