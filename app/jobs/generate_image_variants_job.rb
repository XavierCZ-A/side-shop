class GenerateImageVariantsJob < ApplicationJob
  queue_as :default

  def perform(product)
    product.images.each do |image|
      image.variant(resize_to_fill: [200, 200]).processed
      image.variant(resize_to_fill: [400, 256]).processed
    end
  end
end
