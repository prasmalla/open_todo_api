class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  attr_reader :current_user

private
  def authenticated?
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by(username: username)
      @current_user = user.authenticate(password) if user
    end
  end
end
