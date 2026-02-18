require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "renders the homepage successfully" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "is accessible without authentication" do
      get root_path
      expect(response).not_to redirect_to(new_session_path)
      expect(response).to have_http_status(:success)
    end
  end
end
