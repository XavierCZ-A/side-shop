class CleanupAbandonedCartsJob < ApplicationJob
  queue_as :default


  def perform
    Cart.left_outer_joins(:line_items)
        .where(line_items: { id: nil })
        .where("carts.created_at < ?", 24.hours.ago)
        .in_batches(of: 1000)
        .delete_all
  end
end
