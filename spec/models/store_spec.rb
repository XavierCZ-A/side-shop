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

require 'rails_helper'

RSpec.describe Store, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:products).dependent(:destroy) }
  end
end
