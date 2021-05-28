class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    serialized = ItemSerializer.new(merchant.items)
    render json: serialized
  end
end
