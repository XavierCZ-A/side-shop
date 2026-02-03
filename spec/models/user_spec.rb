require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:email_address) }
    it { should validate_presence_of(:password) }

    # Test de unicidad (ignora mayúsculas/minúsculas)
    it { should validate_uniqueness_of(:email_address).case_insensitive }
    
    # Validaciones de formato o longitud
    it { should validate_length_of(:password).is_at_least(6) }
  end
end
