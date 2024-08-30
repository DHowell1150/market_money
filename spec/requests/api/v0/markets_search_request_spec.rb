require 'rails_helper'

describe "Market Search" do
  describe "index" do
    describe "HAPPY PATHS" do 
      it "can search markets by state, city, and/or name" do
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)
        vendor3 = create(:vendor)
        vendor4 = create(:vendor)
        vendor5 = create(:vendor)


        market1 = create(:market,
                        name: "Nob Hill Growers' Market",
                        street: "Lead & Morningside SE",
                        city: "Albuquerque",
                        county: "Bernalillo",
                        state: "New Mexico",
                        zip: "80226",
                        lat: "35.077529",
                        lon: "-106.600449")

        market2 = create(:market, 
                        name: "Little Hands Clapping",
                        street: "Lynch Trail",
                        city: "Audryland",
                        county: "Bahringerland",
                        state: "Wisconsin",
                        zip: "21738",
                        lat: "-32.35039447997065",
                        lon: "98.80612257180513")

        market3 = create(:market, 
                        name: "Dance Dance Dance",
                        street: "Rafael Manor",
                        city: "East Brad",
                        county: "Roobburgh",
                        state: "Minnesota",
                        zip: "47073",
                        lat: "77.15123760679182",
                        lon: "127.09871083268172")

        MarketVendor.create!(market: market1, vendor: vendor1)
        MarketVendor.create!(market: market1, vendor: vendor2)
        MarketVendor.create!(market: market2, vendor: vendor3)
        MarketVendor.create!(market: market2, vendor: vendor4)
        MarketVendor.create!(market: market3, vendor: vendor5)

        market_search = ({
          state: "Minnesota",
          city: "East Brad",
          name: "Dance Dance Dance"
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        get "/api/v0/markets/search", headers: headers, params: JSON.generate(search: market_search)

        expect(response).to be_successful

        market1 = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to be_a(String)

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)

        expect(market[:attributes][:name]).to eq(market1.name)
        expect(market[:attributes][:street]).to eq(market1.street)
        expect(market[:attributes][:city]).to eq(market1.city)
        expect(market[:attributes][:county]).to eq(market1.county)
        expect(market[:attributes][:state]).to eq(market1.state)
        expect(market[:attributes][:zip]).to eq(market1.zip)
        expect(market[:attributes][:lat]).to eq(market1.lat)
        expect(market[:attributes][:lon]).to eq(market1.lon)
        expect(market[:attributes][:vendor_count]).to eq(market1.count_vendors)
      end
    end

    # describe "SAD PATHS" do 

    # end
  end
end
