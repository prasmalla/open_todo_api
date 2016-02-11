class Api::ListsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find(params[:user_id])
    list = user.lists.build(list_params)

    if list.save
      render json: list, status: 201
    else
      render json: {}, status: 422
    end
  end

  def update
    list = List.find(params[:id])
    if list.update(list_params)
      render json: list, status: 200
    else
      render json: { error: list.errors.full_messages }, status: 422
    end
  end

  def destroy
    begin
      list = List.find(params[:id])
      list.destroy
      render json: {}, status: 204
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: 404
    end
  end

private

  def list_params
    params.require(:list).permit(:name, :permissions)
  end
  # curl --header "Content-type: application/json" -X POST -d '{"list":{"name":"to do", "permissions":"public"}}' http://localhost:3000/api/users/1/lists
  # curl --header "Content-type: application/json" -X PUT -d '{"list":{"permissions":"public"}}' http://localhost:3000/api/users/1/lists/1
  # curl -X DELETE http://localhost:3000/api/users/1/lists/1
end
