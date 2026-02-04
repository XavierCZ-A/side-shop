class HomeController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  skip_before_action :check_onboarding_status

  def index
    @user = Current.user
  end
end
