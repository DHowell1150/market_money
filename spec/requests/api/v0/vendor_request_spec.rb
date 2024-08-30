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
        
        vendor = JSON.parse(response.body, symbolize_names: true)[:data]

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
      it "sends a 404 status and description for invalid vendor" do # js: false do 
        get "/api/v0/vendors/123123123123"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)[:errors]
        
        expect(data).to be_a(Array)
        expect(data.first[:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      end
    end
  end

  describe "index" do 
    describe "Happy Path" do 
      it "can return a market's vendors" do 
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)
        market1 = create(:market)
        MarketVendor.create!(market: market1, vendor: vendor1)
        MarketVendor.create!(market: market1, vendor: vendor2)
        
        get api_v0_market_vendors_path(market1)

        expect(response).to be_successful

        vendors = JSON.parse(response.body, symbolize_names: true)[:data]
        first_vendor = vendors.first

        expect(vendors.count).to eq(2)
        expect(first_vendor).to have_key(:id)
        expect(first_vendor[:id]).to eq(vendor1.id.to_s)
        expect(first_vendor).to have_key(:type)
        expect(first_vendor[:type]).to eq("vendor")
        expect(first_vendor).to have_key(:attributes)
        expect(first_vendor[:attributes]).to be_a(Hash)
        expect(first_vendor[:attributes]).to have_key(:name)
        expect(first_vendor[:attributes][:name]).to eq(vendor1.name)
        expect(first_vendor[:attributes]).to have_key(:description)
        expect(first_vendor[:attributes][:description]).to eq(vendor1.description)
        expect(first_vendor[:attributes]).to have_key(:contact_name)
        expect(first_vendor[:attributes][:contact_name]).to eq(vendor1.contact_name)
        expect(first_vendor[:attributes]).to have_key(:contact_phone)
        expect(first_vendor[:attributes][:contact_phone]).to eq(vendor1.contact_phone)
        expect(first_vendor[:attributes]).to have_key(:credit_accepted)
        expect(first_vendor[:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)
      end
    end

    describe "sad path" do 
      it "can return appropriate error" do 
        get "/api/v0/markets/123123123123/vendors"  

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=123123123123")
      end
    end
  end


  describe "create" do 
    describe "happy paths" do 
      it "creates a vendor" do 
        vendor_attrs = ({
          name: "Some Name",
          description: "Some description that is longer",
          contact_name: "Contact Name",
          contact_phone: "888-888-8888",
          credit_accepted: true
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_attrs)

        expect(response).to be_successful

        vendor = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)
        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq("vendor")
        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)
        
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to eq("Some Name")
        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to eq("Some description that is longer")
        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to eq("Contact Name")
        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to eq("888-888-8888")
        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to eq(true)
      end
    end
    describe "sad paths" do
      it "must have a name" do
        vendor_attrs = ({
          name: "",
          description: "Some description that is longer",
          contact_name: "Contact Name",
          contact_phone: 888-888-8888,
          credit_accepted: false
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_attrs) 
        
        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)[:errors]
        expect(data).to be_a(Array)
        expect(data.first[:detail]).to eq("Validation failed: Name can't be blank")
      end

      it "must have a contact_name" do 
        vendor_attrs = ({
          name: "Some Name",
          description: "Some description that is longer",
          contact_name: "",
          contact_phone: 888-888-8888,
          credit_accepted: true
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_attrs) 
        
        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)[:errors]
        
        expect(data).to be_a(Array)
        expect(data.first[:detail]).to eq("Validation failed: Contact name can't be blank")
      end
    end
  end

  describe "update" do 
    describe "happy paths" do 
      it "can update a vendor" do
        id = create(:vendor).id
        previous_name = Vendor.last.name
        vendor_params = { name: "Tabula Rasa" }
        headers = { "CONTENT_TYPE" => "application/json" }
  
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
  
        vendor = Vendor.find_by(id: id)
        expect(response).to be_successful
        expect(response.status).to eq(200)
      end
    end
  
    describe "sad paths" do
      it "Must have a valid vendor.id" do 
        id = create(:vendor).id
        vendor_params = { contact_name: "Tabula Rasa" }
        headers = { "CONTENT_TYPE" => "application/json" }
  
        patch "/api/v0/vendors/123123123123", headers: headers, params: JSON.generate({vendor: vendor_params})
  
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end

      it "Name can't be blank" do 
        vendor = create(:vendor)
        previous_name = Vendor.last.name
        vendor_params = { name: "" }
        headers = { "CONTENT_TYPE" => "application/json" }
  
        patch "/api/v0/vendors/123123123123", headers: headers, params: JSON.generate({vendor: vendor_params})
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end

  describe "delete" do 
    describe "happy paths" do 
      it "deletes a vendor" do 
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)

        expect(Vendor.count).to eq(2)
        headers = {"CONTENT_TYPE" => "application/json"}
        
        delete "/api/v0/vendors/#{vendor1.id}", headers: headers

        expect(Vendor.count).to eq(1)
        expect(response).to be_successful
      end
    end

    describe "sad paths" do
      it "Must have a valid vendor.id" do 
        id = create(:vendor).id
        vendor_params = { contact_name: "Tabula Rasa" }
        headers = { "CONTENT_TYPE" => "application/json" }
  
        delete "/api/v0/vendors/123123123123", headers: headers
  
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end
end