require 'rails_helper'

describe 'Item API' do
  before :each do
    merchant = create(:merchant)
    customer = create(:customer)
    create_list(:item, 5, merchant_id: merchant.id)
    create_list(:invoice, 5, merchant_id: merchant.id, customer_id: customer.id)
  end
  describe 'Happy Path' do
    xit "deletes an item" do
      item = Item.last

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
    end
  end
end
