class Api::V1::ItemsMerchantController < ApplicationController
  def show
    item = Item.find(params[:id])
    serialized = MerchantSerializer.new(item.merchant)
    render json: serialized
  end
end
