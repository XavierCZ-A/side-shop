class Authentication::SessionsController < ApplicationController
  layout "authentication_layout"
  skip_before_action :check_onboarding_status
  before_action :redirect_if_authenticated, only: %i[ new create ]
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Bienvenido de nuevo"
    else
      @email = params[:email_address]
      @user = User.new
      flash.now[:alert] = "El correo electrónico o la contraseña son incorrectos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def redirect_if_authenticated
    redirect_to admin_root_path if authenticated?
  end
end
