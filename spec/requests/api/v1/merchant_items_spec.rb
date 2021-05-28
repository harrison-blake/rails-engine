require 'rails_helper'

describe 'Merchant Items API' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    create_list(:item, 18, merchant_id: @merchant1.id)
    create_list(:item, 9, merchant_id: @merchant2.id)
  end

  describe 'Happy Path' do
    it 'returns all items for a specific merchant' do
      get "/api/v1/merchants/#{@merchant1.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to_not eq(27)
      expect(items[:data].length).to eq(@merchant1.items.length)
      expect(items[:data].first[:id]).to eq(@merchant1.items.first.id.to_s)
    end
  end
end
