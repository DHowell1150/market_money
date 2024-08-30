- route:
    get '/api/v0/markets/search', to: 'market_search#index'

- spec:
    spec/requests/api/v0/market_search_request_spec.rb
    - Created markets with manual data
    - FactoryBot created vendors

- controller:
    app/controllers/api/v0/search_controller
    - show action since we're to only return one market