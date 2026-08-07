class Admin::AdminBaseController < ApplicationController
  before_action :current_plan
  before_action :set_store

  private

  def set_store
    @store = current_user.store
  end

  def current_plan
    processor = current_user&.payment_processor
    subscription = processor&.subscriptions&.order(created_at: :desc)&.first
    @current_plan ||= subscription&.name || "Basico"
  end
end
