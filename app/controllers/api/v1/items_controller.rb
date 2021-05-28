class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all.paginate(params[:perPage], params[:page])
    serialized = ItemSerializer.new(items)
    render json: serialized
  end

  def show
    item = Item.find(params[:id])
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

  def create
    item = Item.create(item_params)
    serialized = ItemSerializer.new(item)

    if item.save
      render json: serialized, status: :created
    else
      render serialized, status: :no_content
    end
  end

  def update
    item = Item.find(params[:id])
    updated_item = item.update!(item_params)

    if updated_item
      serialized = ItemSerializer.new(item)
      render json: serialized, status: 200
    else
      serialized = ItemSerializer.new(item)
      render serialized, status: :no_content
    end
  end

  def find
    if params[:max_price] || params[:min_price]
      item = Item.find_by_price(params[:min_price], params[:max_price])
      serialized = ItemSerializer.new(item)
      render json: serialized, status: 200
    elsif params[:name]
      item = Item.find_by_search_query(params[:name])
      serialized = ItemSerializer.new(item)
      render json: serialized, status: 200
    else
      render json: {message: "bad params"}, status: 400
    end
  end

  def revenue
    item = Item.top_10_revenue(params[:quantity])
    serialized = ItemRevenueSerializer.new(item)
    render json: serialized, status: 200
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
