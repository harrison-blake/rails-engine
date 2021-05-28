require 'rails_helper'

describe 'Item API' do
  before :each do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)
  end

  describe 'Happy Path' do
    it 'creates an item' do
      item_params = {
        name: 'created item',
        description: 'This is a created item',
        unit_price: 97.90,
        merchant_id: Merchant.first.id
      }

      post '/api/v1/items', { params: item_params }

      expect(response).to be_successful

      item = Item.last

      expect(item.name).to eq(item_params[:name])
      expect(item.unit_price.to_f).to eq(item_params[:unit_price])
    end

    it 'creates an item if user has all required fields and an extra feild' do
      item_params = {
        name: 'created item',
        description: 'This is a created item',
        unit_price: 97.90,
        bulk_price: 85.50,
        merchant_id: Merchant.first.id
      }

      post '/api/v1/items', { params: item_params }

      expect(response).to be_successful

      item = Item.last

      expect(item.name).to eq(item_params[:name])
      expect { item.bulk_price }.to raise_error(NoMethodError)
      expect(item.unit_price.to_f).to eq(item_params[:unit_price])
    end
  end

  describe 'Sad Path' do
    it "return an error if any attribute is missing" do
      item_params = {
        description: 'This is a created item',
        unit_price: 97.90,
        merchant_id: Merchant.first.id
      }

      post '/api/v1/items', { params: item_params }

      expect(response).to have_http_status(:no_content)
    end
  end
end
