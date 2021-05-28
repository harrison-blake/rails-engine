require 'rails_helper'

describe 'Merchants API' do
  before :each do
    create_list(:merchant, 100)
  end

  describe 'Happy Path' do
    it 'returns data back in the correct format' do
      id = Merchant.third.id

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data].length).to eq(3)
      expect(merchant[:data]).to be_an(Hash)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to have_key(:name)
    end

    it 'returns a single merchant if the id is valid' do
      id = Merchant.third.id

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data][:id].to_i).to eq(Merchant.third.id)
    end
  end

  describe 'sad path' do
    it 'raises an error if the id is invalid' do
      id = 109_234

      expect { get "/api/v1/merchants/#{id}" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
