module Storefront
  module SampleProducts
    Sample = Struct.new(:id, :name, :price, :description, :image_url, keyword_init: true) do
      def to_param        = id.to_s
      def persisted?      = false
      def images_attached = false
    end

    DATA = [
      {
        id: "sample-1",
        name: "Vela aromática · Citronela",
        price: 24.0,
        description: "Cera de soja con notas cítricas y herbales.",
        image_url: "/sample/candle.jpg"
      },
      {
        id: "sample-2",
        name: "Cuaderno artesanal",
        price: 18.5,
        description: "Tapa dura de lino con páginas de papel reciclado.",
        image_url: "/sample/notebook.jpg"
      }
    ].freeze

    def self.build
      DATA.map { |attrs| Sample.new(**attrs) }
    end
  end
end
