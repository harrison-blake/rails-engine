require 'rails_helper'

describe 'Merchants API' do
  before :each do
    create_list(:merchant, 100)
  end

  describe "Structure of returned data" do
    it 'returns merchants data in the correct format' do
      get '/api/v1/merchants'

      expect(response).to be_success

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data].length).to eq(20)
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data][0]).to be_a(Hash)
      expect(merchants[:data][0]).to have_key(:id)
      expect(merchants[:data][0]).to have_key(:type)
      expect(merchants[:data][0]).to have_key(:attributes)
      expect(merchants[:data][0][:attributes]).to be_a(Hash)
      expect(merchants[:data][0][:attributes]).to have_key(:name)
      expect(merchants[:data][0][:attributes][:name]).to be_a(String)
    end
  end

  describe 'Happy Path' do
    it 'returns the first 20 merchants if page=1' do
      get '/api/v1/merchants?page=1'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all

      expect(merchants[:data].length).to eq(20)
      expect(merchants[:data][0][:id].to_i).to eq(db_merchants.first.id)
      expect(merchants[:data][19][:id].to_i).to eq(db_merchants[19].id)
      expect(merchants[:data].last[:id].to_i).to_not eq(db_merchants.last.id)
    end

    it 'returns merchants 21-40 if page=2' do
      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all

      expect(merchants[:data].length).to eq(20)
      expect(merchants[:data].first[:id].to_i).to eq(db_merchants[20].id)
      expect(merchants[:data].last[:id].to_i).to eq(db_merchants[39].id)
      expect(merchants[:data].first[:id].to_i).to_not eq(db_merchants.first.id)
      expect(merchants[:data].last[:id].to_i).to_not eq(db_merchants.last.id)
    end

    it 'returns first 50 merchants when perPage=50' do
      get '/api/v1/merchants?perPage=50'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all.order(id: :asc)

      expect(merchants[:data].length).to eq(50)
      expect(merchants[:data].first[:id].to_i).to eq(db_merchants.first.id)
      expect(merchants[:data].second[:id].to_i).to eq(db_merchants.second.id)
      expect(merchants[:data].last[:id].to_i).to eq(db_merchants[49].id)
    end

    it 'returns all merchants when perPage is bigger than number of merchants' do
      get '/api/v1/merchants?perPage=101'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all.order(id: :asc)

      expect(merchants[:data].length).to eq(100)
      expect(merchants[:data].first[:id].to_i).to eq(db_merchants.first.id)
      expect(merchants[:data].second[:id].to_i).to eq(db_merchants.second.id)
      expect(merchants[:data].last[:id].to_i).to eq(db_merchants.last.id)
    end
  end

  describe 'sad path' do
    it 'returns an empty data array if page number is too high' do
      get '/api/v1/merchants?page=300'

      expect(response).to be_successful

      api_merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all

      expect(api_merchants[:data].length).to eq(0)
      expect(api_merchants[:data].empty?).to eq(true)
    end

    it 'returns page 1 if page is 0 or lower' do
      get '/api/v1/merchants?page=-3'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      db_merchants = Merchant.all

      expect(merchants[:data].length).to eq(20)
      expect(merchants[:data].first[:id].to_i).to eq(db_merchants.first.id)
      expect(merchants[:data].last[:id].to_i).to eq(db_merchants[19].id)
    end
  end
end
