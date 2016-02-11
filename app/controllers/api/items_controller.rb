class Api::ItemsController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :set_list
  before_action :authenticated?

  def index
    items = @list.items.all
    # render json: items, each_serializer: ItemSerializer
    render(
      json: ActiveModel::ArraySerializer.new(
        items,
        each_serializer: ItemSerializer,
        root: 'items',
      )
    )
  end

  def create
    if current_user == @list.user
      item = @list.items.build(item_params)
      if item.save
        render json: item, status: 201
      else
        render json: item.errors.full_messages, status: 422
      end
    else
      render json: {}, status: 401
    end
  end

  def update
    item = @list.items.find(params[:id])
    if (current_user == item.list.user) && item.update(item_params)
      render json: item, status: 200
    else
      render json: item.errors.full_messages, status: 422
    end
  end

  def destroy
    begin
      item = @list.items.find(params[:id])
      if (current_user == item.list.user) && item.destroy
        render json: {}, status: 204
      else
        render json: {}, status: 401
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: 404
    end
  end

private

  def item_params
    params.require(:item).permit(:description, :completed)
  end

  def set_list
    @list = List.find(params[:list_id])
  end
  # curl http://localhost:3000/api/lists/1/items
  # curl --header "Content-type: application/json" -X POST -d '{"item":{"description":"first to do"}}' http://localhost:3000/api/lists/1/items
  # curl --header "Content-type: application/json" -X PUT -d '{"item":{"description":"to do"}}' http://localhost:3000/api/lists/1/items/1
  # curl -X DELETE http://localhost:3000/api/lists/1/items/1
end
