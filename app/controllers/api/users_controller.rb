class Api::UsersController < ApiController
  before_action :authenticated?

  def index
    users = User.all
    # render json: users, each_serializer: UserSerializer
    render(
      json: ActiveModel::ArraySerializer.new(
        users,
        each_serializer: UserSerializer,
        root: 'users',
      )
    )
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: 201
    else
      render json: user.errors.full_messages, status: 422
    end
  end

  def destroy
    begin
      user = User.find(params[:id])
      user.destroy
      render json: {}, status: 204
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: 404
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
  # curl http://localhost:3000/api/users
  # curl -v -H "Accept: application/json" --header "Content-type: application/json" -X POST -d '{"user":{"email":"api@api.com", "username":"api", "password":"api"}}'  http://localhost:3000/api/users/
  # curl -X DELETE http://localhost:3000/api/users/1/
end
