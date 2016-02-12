class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :cors_preflight_check
  after_filter :set_access_control_headers
  attr_reader :current_user

private
  def authenticated?
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by(username: username)
      @current_user = user.authenticate(password) if user
    end
  end

  # CORS
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Origin, Content-Type'
  end

  # CORS preflight sanity checks client/server to allow legacy servers to support CORS
  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Origin, X-Requested-With, X-Prototype-Version, Content-Type'
    headers['Access-Control-Max-Age'] = '1728000'
    render text: "" if request.method == "OPTIONS"
  end
end
