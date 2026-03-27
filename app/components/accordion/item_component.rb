# frozen_string_literal: true

module Accordion
  class ItemComponent < ViewComponent::Base
    attr_reader :disabled, :title

      # @param title [String] The accordion item title/question
      # @param default_open [Boolean] Whether item starts expanded
      # @param disabled [Boolean] Whether item is disabled (non-interactive)
      # @param icon_position [Symbol] Icon position: :left or :right
      # @param icon [Symbol] Icon type inherited from parent: :chevron, :plus_minus, :left_arrow
      # @param variant [Symbol] Style variant inherited from parent
      # @param classes [String] Additional CSS classes
      def initialize(title:, default_open: false, disabled: false, icon_position: :right, icon: :chevron, variant: :default, classes: nil)
        super()
        @title = title
        @default_open = default_open
        @disabled = disabled
        @icon_position = icon_position
        @icon = icon
        @variant = variant
        @classes = classes
      end

      def unique_id
        @unique_id ||= SecureRandom.hex(4)
      end

      def state
        @default_open ? "open" : "closed"
      end

      def aria_expanded
        @default_open ? "true" : "false"
      end

      def content_hidden?
        !@default_open
      end

      def icon_left?
        @icon_position == :left
      end

      def bordered?
        @variant == :bordered
      end

      # Styling methods
      def item_classes
        base = case @variant
               when :bordered
                 "overflow-hidden rounded-xl border border-[#D1D5DB] bg-white transition-colors"
               when :floating
                 "mb-2"
               else
                 "border-b border-[#E5E7EB]"
               end
        [@classes, base].compact.join(" ")
      end

      def h3_classes
        bordered? ? "flex mt-0 mb-0" : "flex mt-1 mb-0"
      end

      def trigger_classes
        # Icon rotation class based on icon type
        icon_class = case @icon
                     when :plus_minus
                     when :left_arrow
                       "[&[data-state=open]>svg]:rotate-0 [&[data-state=closed]>svg]:-rotate-90"
                     else
                       "[&[data-state=open]>svg]:rotate-180"
                     end

        if bordered?
          base = "w-full min-h-12 rounded-xl flex flex-1 items-center justify-between gap-3 px-3.5 py-3 text-sm sm:text-base font-medium text-[#1A2B3C] transition-colors active:bg-[#F3F4F6]"
          focus = "focus:outline-[#10B981] focus:-outline-offset-1"
          class_names(base, icon_class, focus)
          # [base, icon_class, focus].reject(&:empty?).join(" ")
        else
          base = "w-full min-h-12 flex flex-1 items-center text-left gap-3 px-2.5 py-3 text-sm sm:text-base font-medium text-[#1A2B3C] transition-colors active:bg-[#F3F4F6]"
          justify = @icon_position == :left ? "" : "justify-between"
          hover = "hover:underline focus:outline-[#10B981] focus:outline-offset-2"
          class_names(base, justify, hover, icon_class)
          # [base, justify, hover, icon_class].reject(&:empty?).join(" ")
        end
      end

      def disabled_trigger_classes
        if bordered?
          "w-full min-h-12 rounded-xl flex flex-1 items-center justify-between gap-3 px-3.5 py-3 text-sm sm:text-base font-medium opacity-50 cursor-not-allowed"
        else
          "w-full min-h-12 flex flex-1 items-center text-left justify-between gap-3 px-2.5 py-3 text-sm sm:text-base font-medium opacity-50 cursor-not-allowed"
        end
      end

      def content_classes
        # CSS Grid approach for smooth animation that handles nested content
        "grid transition-[grid-template-rows] duration-300 ease-in-out data-[state=open]:grid-rows-[1fr] data-[state=closed]:grid-rows-[0fr]"
      end

      def content_inner_classes
        "overflow-hidden min-h-0"
      end

      def content_body_classes
        "opacity-0 transition-opacity duration-300 data-[state=open]:opacity-100"
      end

      def content_padding_classes
        bordered? ? "px-3.5 py-3 sm:px-4 sm:py-3.5 bg-white text-sm leading-6 text-[#4B5563]" : "my-1.5 px-2.5 py-1 text-sm leading-6 text-[#4B5563]"
      end

      def render_icon(static: false)
        case @icon
        when :plus_minus
          render_plus_minus_icon(static: static)
        when :left_arrow
          render_left_arrow_icon(static: static)
        else
          render_chevron_icon(static: static)
        end
      end

      private

      def icon_color_class
        " text-[#4B5563]"
      end

      def render_chevron_icon(static: false)
        classes = "size-4 shrink-0 transition-transform duration-300#{icon_color_class}"
        classes += " rotate-180" if !static && @default_open

        chevron_path = "M8.99999 13.5C8.80799 13.5 8.61599 13.4271 8.46999 13.2801L2.21999 7.03005C1.92699 " \
                       "6.73705 1.92699 6.26202 2.21999 5.96902C2.51299 5.67602 2.98799 5.67602 3.28099 " \
                       "5.96902L9.00099 11.689L14.721 5.96902C15.014 5.67602 15.489 5.67602 15.782 5.96902C16.075 " \
                       "6.26202 16.075 6.73705 15.782 7.03005L9.53199 13.2801C9.38599 13.4261 9.19399 13.5 9.00199 13.5H8.99999Z"

        svg_options = {
          xmlns: "http://www.w3.org/2000/svg",
          class: classes,
          width: "18",
          height: "18",
          viewBox: "0 0 18 18",
          'data-accordion-target': static ? nil : "icon"
        }

        content_tag(:svg, svg_options) do
          content_tag(:g, fill: "currentColor") do
            content_tag(:path, nil, d: chevron_path)
          end
        end
      end

      def render_plus_minus_icon(static: false)
        horizontal_path = "M14.75,9.75H3.25c-.414,0-.75-.336-.75-.75s.336-.75,.75-.75H14.75c.414,0,.75,.336,.75,.75s-.336,.75-.75,.75Z"
        vertical_path = "M9,15.5c-.414,0-.75-.336-.75-.75V3.25c0-.414,.336-.75,.75-.75s.75,.336,.75,.75V14.75c0,.414-.336,.75-.75,.75Z"
        vertical_class = "origin-center transition-all duration-300 scale-100 [button[aria-expanded=true]_&]:scale-0"

        svg_options = {
          xmlns: "http://www.w3.org/2000/svg",
          class: "size-4#{icon_color_class}",
          width: "18",
          height: "18",
          viewBox: "0 0 18 18",
          'data-accordion-target': static ? nil : "icon"
        }

        content_tag(:svg, svg_options) do
          content_tag(:g, fill: "currentColor") do
            horizontal = content_tag(:path, nil, d: horizontal_path)
            vertical = content_tag(:path, nil, d: vertical_path, class: vertical_class)
            horizontal + vertical
          end
        end
      end

      def render_left_arrow_icon(static: false)
        rotation_class = @default_open && !static ? "rotate-0" : "-rotate-90"

        classes = "size-4 shrink-0 transition-transform duration-300 #{rotation_class}#{icon_color_class}"

        arrow_path = "M8.99999 13.5C8.80799 13.5 8.61599 13.4271 8.46999 13.2801L2.21999 7.03005C1.92699 " \
                     "6.73705 1.92699 6.26202 2.21999 5.96902C2.51299 5.67602 2.98799 5.67602 3.28099 " \
                     "5.96902L9.00099 11.689L14.721 5.96902C15.014 5.67602 15.489 5.67602 15.782 5.96902C16.075 " \
                     "6.26202 16.075 6.73705 15.782 7.03005L9.53199 13.2801C9.38599 13.4261 9.19399 13.5 9.00199 13.5H8.99999Z"

        svg_options = {
          xmlns: "http://www.w3.org/2000/svg",
          class: classes,
          width: "18",
          height: "18",
          viewBox: "0 0 18 18",
          'data-accordion-target': static ? nil : "icon"
        }

        content_tag(:svg, svg_options) do
          content_tag(:g, fill: "currentColor") do
            content_tag(:path, nil, d: arrow_path)
          end
        end
      end
  end
end
