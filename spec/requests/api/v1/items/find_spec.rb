require 'rails_helper'

describe 'Item Search API endpoint' do
  before :each do
    @merchant = create(:merchant)
    @item1 = create(:item, name: "test1", unit_price: 30.99, merchant_id: @merchant.id)
    @item2 = create(:item, name: "test2", unit_price: 20.99, merchant_id: @merchant.id)
    @item3 = create(:item, name: "test3", unit_price: 10.99, merchant_id: @merchant.id)
  end

  describe 'structure of returned data' do
    it 'returns data back in the correct format' do
      min_price = 25

      get "/api/v1/items/find?min_price=#{min_price}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data].length).to eq(3)
      expect(item[:data]).to be_an(Hash)
      expect(item[:data]).to have_key(:id)
      expect(item[:data]).to have_key(:type)
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to have_key(:name)
    end
  end

    describe 'Happy Path' do
      it "returns 1 item thats geater than min price search query" do
        min_price = 25
        get "/api/v1/items/find?min_price=#{min_price}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes][:name]).to include(@item1.name)
        expect(item[:data][:attributes][:description]).to include(@item1.description)
        expect(item[:data][:attributes][:unit_price]).to be >= 25
      end

      xit "returns 0 items when min price is too big" do
        min_price = 10000000
        get "/api/v1/items/find?min_price=#{min_price}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes][:name]).to include(@item1.name)
        expect(item[:data][:attributes][:description]).to include(@item1.description)
        expect(item[:data][:attributes][:unit_price]).to be >= 25
      end

      it "returns 1 item thats less than max price search query" do
        max_price = 25

        get "/api/v1/items/find?max_price=#{max_price}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes][:name]).to eq(@item2.name)
        expect(item[:data][:attributes][:description]).to eq(@item2.description)
        expect(item[:data][:attributes][:unit_price]).to be <= 25
      end

      it "returns 1 item in between min and max price" do
        max_price = 25
        min_price = 15
        get "/api/v1/items/find?max_price=#{max_price}&min_price=#{min_price}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes][:name]).to include(@item2.name)
        expect(item[:data][:attributes][:description]).to include(@item2.description)
        expect(item[:data][:attributes][:unit_price]).to be <= 25
        expect(item[:data][:attributes][:unit_price]).to be >= 15
      end

      it "returns 1 item that matches name search query" do
        name = "test"
        get "/api/v1/items/find?name=#{name}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes][:name]).to include(name)
        expect(item[:data][:attributes][:name]).to include(@item1.name)
        expect(item[:data][:attributes][:description]).to include(@item1.description)
      end
    end

    describe 'Sad Path' do
      it "returns 0 items if bad search query" do
        name = "nothing"
        get "/api/v1/items/find?name=#{name}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to eq(nil)
      end
    end
  end
