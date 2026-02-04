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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_one(:store).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of(:email_address) }
    it { should validate_presence_of(:password) }

    # Test de unicidad (ignora mayúsculas/minúsculas)
    it { should validate_uniqueness_of(:email_address).case_insensitive }

    it "normalizes email_address" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      expect(user.email_address).to eq("test@example.com")
    end
    
    # Validaciones de formato o longitud
    it { should validate_length_of(:password).is_at_least(6) }
  end
end
