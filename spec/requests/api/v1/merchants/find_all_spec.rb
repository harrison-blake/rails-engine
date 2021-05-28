require 'rails_helper'

describe 'Find all Merchant that match search query API endpoint' do
  before :each do
    merchant1 = create(:merchant, name: "General Mart")
    merchant2 = create(:merchant, name: "Super Mart")
    merchant3 = create(:merchant, name: "Marty's General Store")
    merchant4 = create(:merchant, name: "Big Mart")
    @search = 'Mart'
  end

  describe "Structure of returned data" do
    it 'returns all merchants data in the correct format' do
      get "/api/v1/merchants/find_all?name=#{@search}"

      expect(response).to be_success

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data].length).to eq(4)
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
    it "returns up to 20 results that match search term" do
        get "/api/v1/merchants/find_all?name=#{@search}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].length).to eq(4)
      expect(merchants[:data][0][:attributes][:name]).to include(@search)
      expect(merchants[:data][1][:attributes][:name]).to include(@search)
      expect(merchants[:data][2][:attributes][:name]).to include(@search)
      expect(merchants[:data].last[:attributes][:name]).to include(@search)
    end
  end

  describe 'Sad Path' do
    it "returns an empty hash when search term returns doesn't match any records" do
        get "/api/v1/merchants/find_all?name=this"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].length).to eq(0)
    end
  end
end
