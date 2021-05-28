require 'rails_helper'

describe 'Items API' do
  before :each do
    merchant = create(:merchant)
    create_list(:item, 100, merchant_id: merchant.id)
  end

  describe "Structure of returned data" do
    it 'returns items data in the correct format' do
      get '/api/v1/items'

      expect(response).to be_success

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      expect(items).to have_key(:data)
      expect(items[:data].length).to eq(20)
      expect(items[:data]).to be_an(Array)
      expect(items[:data][0]).to be_a(Hash)
      expect(items[:data][0]).to have_key(:id)
      expect(items[:data][0]).to have_key(:type)
      expect(items[:data][0]).to have_key(:attributes)
      expect(items[:data][0][:attributes]).to be_a(Hash)
      expect(items[:data][0][:attributes]).to have_key(:name)
      expect(items[:data][0][:attributes]).to have_key(:description)
      expect(items[:data][0][:attributes]).to have_key(:unit_price)
      expect(items[:data][0][:attributes][:name]).to be_a(String)
      expect(items[:data][0][:attributes][:description]).to be_a(String)
      expect(items[:data][0][:attributes][:unit_price]).to be_a(Float)
      expect(items[:data][0][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'Happy Path' do
    it 'returns the first 20 items if page=1' do
      get '/api/v1/items?page=1'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(items[:data].length).to eq(20)
      expect(items[:data][0][:id].to_i).to eq(db_items.first.id)
      expect(items[:data][19][:id].to_i).to eq(db_items[19].id)
      expect(items[:data].last[:id].to_i).to_not eq(db_items.last.id)
    end

    it 'returns items 21-40 if page=2' do
      get '/api/v1/items?page=2'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(items[:data].length).to eq(20)
      expect(items[:data].first[:id].to_i).to eq(db_items[20].id)
      expect(items[:data].last[:id].to_i).to eq(db_items[39].id)
      expect(items[:data].first[:id].to_i).to_not eq(db_items.first.id)
      expect(items[:data].last[:id].to_i).to_not eq(db_items.last.id)
    end

    it 'returns first 50 items when perPage=50 and page defaults to first page' do
      get '/api/v1/items?perPage=50'

      expect(response).to be_successful

      api_items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(api_items[:data].length).to eq(50)
      expect(api_items[:data].first[:id].to_i).to eq(db_items.first.id)
      expect(api_items[:data][49][:id].to_i).to eq(db_items[49].id)
      expect(api_items[:data].last[:id].to_i).to_not eq(db_items.last.id)
    end

    it 'returns all items when perPage is really big' do
      get '/api/v1/items?perPage=1000'

      expect(response).to be_successful

      api_items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(api_items[:data].length).to eq(100)
      expect(api_items[:data].first[:id].to_i).to eq(db_items.first.id)
      expect(api_items[:data][49][:id].to_i).to eq(db_items[49].id)
      expect(api_items[:data].last[:id].to_i).to eq(db_items.last.id)
    end
  end

  describe 'sad path' do
    it 'returns an empty data array if page number is too high' do
      get '/api/v1/items?page=300'

      expect(response).to be_successful

      api_items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(api_items[:data].length).to eq(0)
      expect(api_items[:data].empty?).to eq(true)
    end

    it 'returns page 1 if page is 0 or lower' do
      get '/api/v1/items?page=-3'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      db_items = Item.all

      expect(items[:data].length).to eq(20)
      expect(items[:data].first[:id].to_i).to eq(db_items.first.id)
      expect(items[:data].last[:id].to_i).to eq(db_items[19].id)
    end
  end
end
