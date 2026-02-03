class Authentication::UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to onboardings_path
    else
      render :new
    end
  end

  private

  def user_params
    params.expect(user: [ :email_address, :password ])
  end
end
