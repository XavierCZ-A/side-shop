class GenerateImageVariantsJob < ApplicationJob
  queue_as :default
  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_concurrency_rule(
    label: -> { "processing_image_#{arguments.first.id}" },
    total_limit: 1
  )
  retry_on ImageProcessing::Error, wait: :polynomially_longer, attempts: 3
  retry_on Vips::Error, wait: :polynomially_longer, attempts: 3
  discard_on ActiveStorage::FileNotFoundError

  def perform(product)
    product.images.each do |image|
      image.variant(resize_to_fill: [ 200, 200 ]).processed
      image.variant(resize_to_fill: [ 400, 256 ]).processed
    end
  end
end
