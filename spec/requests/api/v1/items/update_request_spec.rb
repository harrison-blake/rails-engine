require 'rails_helper'

describe 'Item API' do
  before :each do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)
  end

  describe 'Happy Path' do
    it 'updates an item with all params changed' do
      item_params = {
        name: 'updated item',
        description: 'This is an updated item',
        unit_price: 100.01,
        merchant_id: Merchant.first.id
      }

      item = Item.first

      put "/api/v1/items/#{item.id}", { params: item_params }

      expect(response).to be_successful

      expect(Item.first.name).to eq(item_params[:name])
      expect(Item.first.description).to eq(item_params[:description])
      expect(Item.first.unit_price).to eq(item_params[:unit_price])
    end

    it 'updates an item with only name and description param' do
      item_params = {
        name: 'updated item',
        description: 'This is an updated item',
      }

      item = Item.first
      price = item.unit_price

      put "/api/v1/items/#{item.id}", { params: item_params }

      expect(response).to be_successful

      expect(Item.first.name).to eq(item_params[:name])
      expect(Item.first.description).to eq(item_params[:description])
      expect(Item.first.unit_price).to eq(price)
    end
  end
end
