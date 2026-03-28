class StoreSubdomain
  EXCLUDED = %w[www app api admin].freeze

  def self.matches?(request)
    subdomain = request.subdomain
    subdomain.present? && EXCLUDED.exclude?(subdomain)
  end
end