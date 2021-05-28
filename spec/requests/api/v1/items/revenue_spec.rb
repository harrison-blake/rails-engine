require 'rails_helper'

RSpec.describe 'Revenue for items' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    create_list(:item, 20, merchant_id: @merchant1.id)
    create_list(:item, 30, merchant_id: @merchant2.id)
  end

  describe 'structure of returned data' do
      xit 'returns top 10 items by revenue data in the correct format' do
        get "/api/v1/revenue/items"

        expect(response).to be_success

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
        expect(items[:data][0][:attributes][:revenue]).to be_a(Float)
        expect(items[:data][0][:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
