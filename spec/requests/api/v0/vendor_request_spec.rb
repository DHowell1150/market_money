require 'rails_helper'

describe "Vendors API" do
  describe "show" do
    describe "HAPPY PATHS" do 
      it "sends a Vendor" do
        vendor1 = create(:vendor)
        # vendor2 = create(:vendor, id: 99999999)
        market1 = create(:market)
        market2 = create(:market)
        market3 = create(:market)

        MarketVendor.create!(market: market1, vendor: vendor1)
        MarketVendor.create!(market: market2, vendor: vendor1)
        MarketVendor.create!(market: market3, vendor: vendor1)

        get "/api/v0/vendors/#{vendor1.id}"

        expect(response).to be_successful

        vendors = JSON.parse(response.body, symbolize_names: true)[:data]

        vendor = vendors.first

          expect(vendor).to have_key(:id)
          expect(vendor[:id]).to be_a(String)

          expect(vendor).to have_key(:type)
          expect(vendor[:type]).to be_a(String)

          expect(vendor).to have_key(:attributes)
          expect(vendor[:attributes]).to be_a(Hash)
          
          expect(vendor[:attributes]).to have_key(:name)
          expect(vendor[:attributes][:name]).to be_a(String)
          
          expect(vendor[:attributes]).to have_key(:description)
          expect(vendor[:attributes][:description]).to be_a(String)
          
          expect(vendor[:attributes]).to have_key(:contact_name)
          expect(vendor[:attributes][:contact_name]).to be_a(String)
          
          expect(vendor[:attributes]).to have_key(:contact_phone)
          expect(vendor[:attributes][:contact_phone]).to be_a(String)

          expect(vendor[:attributes]).to have_key(:credit_accepted)
          expect(vendor[:attributes][:credit_accepted]).to be(true).or be(false)
      end
    end
    describe 'SAD PATHS' do 
      xit "sends a 404 status and description for invalid vendor" do # js: false do 
        vendor1 = create(:vendor, id: 99999999)
        market1 = create(:market)

        MarketVendor.create!(market: market1, vendor: vendor1)

        get "/api/v0/vendors/#{vendor1.id}"

        expect(response).to be_unsuccessful
        expect(page.status_code).to eq(404)
        response = JSON.parse(response.body, symbolize_names: true)[:errors]
require 'pry' ; binding.pry
      end
    end
  end

  describe "create" do 
    describe "happy paths" do 
      it "creates a vendor" do 

      end
    describe "sad paths" do
      it "something" do

      end
    end
      it "can update a vendor" do
        
      end

      it "can delete a vendor" do

      end
    end
  end
end