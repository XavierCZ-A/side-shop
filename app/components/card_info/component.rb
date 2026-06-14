# frozen_string_literal: true

module CardInfo
  class Component < ViewComponent::Base
    VARIANTS = %i[default success danger].freeze

    # Name of the param each element is passed to when using `with_collection`.
    with_collection_parameter :stat

    # @param label [String] Small uppercase heading (e.g. "Catálogo")
    # @param value [String, Integer] The main figure shown large (e.g. 6)
    # @param subtitle [String] Supporting text below the value
    # @param variant [Symbol] Color of the value: :default, :success, :danger
    # @param stat [Hash] Collection element holding the keys above (used by `with_collection`)
    def initialize(label: nil, value: nil, subtitle: nil, variant: :default, stat: nil)
      super()
      label, value, subtitle, variant = stat.values_at(:label, :value, :subtitle, :variant) if stat

      @label = label
      @value = value
      @subtitle = subtitle
      @variant = VARIANTS.include?(variant) ? variant : :default
    end

    private

    attr_reader :label, :value, :subtitle

    def value_color
      case @variant
      when :success then "text-green-700"
      when :danger  then "text-red-600"
      else "text-primary"
      end
    end
  end
end
