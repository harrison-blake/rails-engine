class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all.paginate(params[:perPage], params[:page])
    serialized  = MerchantSerializer.new(merchants)
    render json: serialized
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find_all
    merchants = Merchant.find_all_by_price(params[:name]).paginate(params[:perPage], params[:page])
    serialized  = MerchantSerializer.new(merchants)
    render json: serialized
  end
end
