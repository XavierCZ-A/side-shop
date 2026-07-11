# frozen_string_literal: true

module Tabs
  class Component < ViewComponent::Base
    renders_many :tabs, "TabComponent"

    class TabComponent < ViewComponent::Base
      attr_reader :label, :id

      def initialize(label:, id:, active: false)
        @label = label
        @id = id
        @active = active
      end

      def active? = @active

      def call
        content
      end
    end
  end
end
