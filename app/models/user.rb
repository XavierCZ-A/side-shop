# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email_address   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#

class User < ApplicationRecord
  pay_customer default_payment_processor: :stripe
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :store, dependent: :destroy

  alias_attribute :email, :email_address
  
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def subscribed?
    payment_processor&.subscribed? || false
  end

  def on_trial?
    trial_ends_at? && trial_ends_at > Time.current
  end

  def active_subscription
    payment_processor&.subscription
  end
end
