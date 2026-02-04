require 'rails_helper'

RSpec.describe Store, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:products).dependent(:destroy) }
  end
end
