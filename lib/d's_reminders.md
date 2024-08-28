- Created vendor_request spec.
finished happy path
working on sad path
- Created VendorSerializer using gem
- Used VendorSerializer in vendor controller show action
- ~~changed variable in vendor = JSON.parse(response.body, symbolize_names: true)[:data] in request_spec from vendor to request.  As I was working on sad paths, I realized that’s what this variable truly is. It’s a response.  Then below that line we define what object we are returning~~
  - ~~eg spec/requests/api/v0/vendor_request_spec.rb line 21 and 22~~
- NOTE: I structured describe blocks for happy and sad paths this way if we want to try for continuity.  I’d like to see what you came up with too.

```ruby
require 'rails_helper'

describe "Vendors API" do
  describe "show" do
    describe "HAPPY PATHS" do 
      it "sends a Vendor" do
        vendor1 = create(:vendor)
        # vendor2 = create(:vendor, id: 99999999)
        market1 = create(:market)
        market2 = create(:market)
        .......
      end
    end
    describe 'SAD PATHS'
      it 'sends a 404 status and description for invalid vendor" do 
        ...code...
      end
    end
  end
end
```

- Merged market_show
- fixed merge conficts from `coverage` files
- added coverage to `.gitignore`