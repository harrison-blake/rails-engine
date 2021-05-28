require 'rails_helper'

describe 'Items Merchant API' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    create_list(:item, 18, merchant_id: @merchant1.id)
    create_list(:item, 9, merchant_id: @merchant2.id)
  end

  describe 'Happy Path' do
    it 'returns all items for a specific merchant' do
      get "/api/v1/items/#{Item.first.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchant[:data].length).to eq(3)
      expect(merchant[:data][:attributes][:name]).to eq(Item.first.merchant.name)
      expect(merchant[:data][:id]).to eq(Item.first.merchant.id.to_s)
    end
  end
end
