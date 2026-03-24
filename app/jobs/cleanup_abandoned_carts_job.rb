class CleanupAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    empty_carts = Cart.left_outer_joins(:line_items)
                      .where(line_items: { id: nil })
                      .where("carts.created_at < ?", 2.minutes.ago)
    
    count = empty_carts.count
    empty_carts.destroy_all
    Rails.logger.info "CleanupAbandonedCartsJob: Deleted #{count} abandoned carts"
  end
end
