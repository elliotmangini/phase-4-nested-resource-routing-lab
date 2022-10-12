class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: User.find(params[:user_id]).items.create(item_params), status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response(target)
    render json: { error: "#{target} not in database"}, status: :not_found
  end


end
