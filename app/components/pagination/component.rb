# frozen_string_literal: true

module Pagination
  class Component < ViewComponent::Base
    include ApplicationHelper
    # @param pagy [Pagy] The Pagy instance returned by `pagy(...)` in the controller
    def initialize(pagy:)
      super()
      @data = pagy.data_hash
    end

    # Hide the whole nav when there is a single page.
    def render?
      @data[:last].to_i > 1
    end

    private

    attr_reader :data

    def series
      data[:series] || []
    end

    def previous_url
      data[:previous_url]
    end

    def next_url
      data[:next_url]
    end

    def page_url(page)
      data[:url_template].sub(Pagy::PAGE_TOKEN, page.to_s)
    end

    def range_label
      "#{data[:from]}–#{data[:to]} de #{data[:count]}"
    end

    def link_classes
      "inline-flex size-9 items-center justify-center rounded-lg border border-gray-200 " \
        "text-sm text-gray-600 transition-colors hover:bg-gray-50"
    end

    def current_classes
      "inline-flex size-9 items-center justify-center rounded-lg border border-primary " \
        "bg-primary text-sm font-medium text-white"
    end

    def gap_classes
      "inline-flex size-9 items-center justify-center text-sm text-gray-400"
    end

    def edge_classes(enabled)
      base = "inline-flex size-9 items-center justify-center rounded-lg border border-gray-200 transition-colors"
      enabled ? "#{base} text-gray-600 hover:bg-gray-50" : "#{base} cursor-not-allowed text-gray-300"
    end
  end
end
