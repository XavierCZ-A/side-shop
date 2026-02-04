class Onboarding::Step
  include ActiveModel::Model

  attr_accessor :id, :title, :description, :fields

  def to_param = id
end
