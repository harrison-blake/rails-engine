describe 'Items API' do
  before :each do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)
  end

  describe 'structure of returned data' do
    it 'returns data back in the correct format' do
      id = Item.third.id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data].length).to eq(3)
      expect(item[:data]).to be_an(Hash)
      expect(item[:data]).to have_key(:id)
      expect(item[:data]).to have_key(:type)
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes]).to have_key(:unit_price)
    end
  end
  describe 'Happy Path' do
    it 'returns a single item if the id is valid' do
      id = Item.third.id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data][:id].to_i).to eq(id)
    end
  end

  describe 'Sad Path' do
    it 'raises an error if the id is invalid' do
      id = 187_232

      expect { get "/api/v1/items/#{id}" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
