module AuthenticationHelpers
  def login_as(user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end
end
