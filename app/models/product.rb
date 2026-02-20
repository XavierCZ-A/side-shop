class Product < ApplicationRecord
  has_many_attached :images, dependent: :destroy

  belongs_to :store
  has_many :line_items

  # after_commit :generate_variants, on: [:create, :update], if: -> { images.attached? }


  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :images, presence: true
  validate :image_count_within_limits
  validate :acceptable_images

  # VARIANTS = {
  #   thumb: { resize_to_fill: [150, 150] },
  #   card: { resize_to_fill: [400, 400] },
  #   large: { resize_to_limit: [1000, 1000] }
  # }

  private

  def image_count_within_limits
    if images.length > 2
      errors.add(:images, "máximo 2 imágenes por producto")
    elsif images.length < 1
      errors.add(:images, "debes subir al menos 1 imagen")
    end
  end
  
  def acceptable_images
    images.each do |image|
      if image.blob.byte_size > 10.megabytes
        errors.add(:images, "#{image.filename} es muy pesada (máximo 10MB)")
      end
      
      unless image.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:images, "#{image.filename} debe ser JPG, PNG o WebP")
      end
    end
  end
  
  # def generate_variants
  #   GenerateImageVariantsJob.perform_later(self)
  # end
end
