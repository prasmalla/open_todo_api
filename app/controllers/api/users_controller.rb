class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    users = User.all
    render json: users
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.destroy
      render json: {}, status: 204
    else
      render json: {}, status: 404
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
  # curl -v -H "Accept: application/json" --header "Content-type: application/json" -X POST -d '{"user":{"email":"api@api.com", "username":"api", "password":"api"}}'  http://localhost:3000/api/users/

end
