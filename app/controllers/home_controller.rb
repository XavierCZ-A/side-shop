class HomeController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  skip_before_action :check_onboarding_status

  def index
    @plans = PricingPlan.all
  end
end
