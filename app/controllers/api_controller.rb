class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

private
  def authenticated?
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by(username: username)
      user.authenticate(password)
    end
  end
end
