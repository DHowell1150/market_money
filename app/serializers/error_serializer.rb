class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      errors: [
        {
          detail: @error_object.message
        }
      ]
    }
  end

  def market_not_found 
    {
      errors: [
          {
              detail: "Validation failed: Market must exist"
          }
      ]
    }
  end

  def market_vendor_exists(market, vendor)
    {
      errors: [
          {
              detail: "Validation failed: Market vendor asociation between market with market_id=#{market} and vendor_id=#{vendor} already exists"
          }
      ]
  }
  end
end