# frozen_string_literal: true

module Table
  class Component < ViewComponent::Base
    include ApplicationHelper
    # @param products [Enumerable<Product>] The products to list in the table
    # @param sort [String, nil] Currently sorted column (see Product::SORTABLE)
    # @param dir [String, nil] Current sort direction ("asc" or "desc")
    def initialize(products:, sort: nil, dir: nil)
      super()
      @products = products
      @sort = sort
      @dir = dir
    end

    def render?
      @products.present?
    end

    private

    attr_reader :products, :sort, :dir


    def sort_link(label, field)
      active = sort.to_s == field.to_s
      next_dir = active && dir == "asc" ? "desc" : "asc"

      query = helpers.request.query_parameters.merge("sort" => field, "dir" => next_dir).except("page")

      link_classes = [
        "group/sort -mx-2 inline-flex items-center gap-1.5 rounded-lg px-2 py-1",
        "cursor-pointer transition-colors hover:bg-gray-100",
        active ? "text-primary" : "text-gray-400 hover:text-gray-700"
      ].join(" ")

      link_to admin_products_path(query),
        data: { turbo_frame: "_top" },
        title: "Ordenar por #{label.downcase}",
        "aria-label": "Ordenar por #{label.downcase}",
        class: link_classes do
        safe_join([ content_tag(:span, label), sort_icon(active) ])
      end
    end

    def sort_icon(active)
      return render_svg("chevron_up_down.svg", styles: "w-4 h-4 text-gray-300 transition-colors group-hover/sort:text-gray-500") unless active

      render_svg(dir == "desc" ? "chevron_down.svg" : "chevron_up.svg", styles: "w-4 h-4 text-primary")
    end

    def status_text(product)
      product.active? ? "Activo" : "Inactivo"
    end

    def status_variant(product)
      product.active? ? :green : :neutral
    end

    def thumbnail(product)
      return unless product.images.attached?

      product.images.first.variant(resize_to_fill: [ 80, 80 ])
    end
  end
end
