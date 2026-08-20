module StoreScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_store_from_subdomain
  end

  private

  def set_store_from_subdomain
    slug = request.subdomain
    @current_store = Store.find_by!(slug: slug)
  rescue ActiveRecord::RecordNotFound
    render template: "errors/store_not_found", status: :not_found
  end
end
