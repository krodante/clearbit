module Plaid
  class Client
    include HTTParty
    BASE = 'https://sandbox.plaid.com/'.freeze

    def initialize; end

    def transactions(start_date, end_date)
      body = auth_body.merge({start_date: start_date, end_date: end_date})
      response = HTTParty.post(BASE + 'transactions/get', headers: headers, body: body.to_json)
      JSON[response.body]['transactions']
    end

    def request(endpoint, request_body)
      body_with_auth = auth_body.merge(request_body)
      response = HTTParty.post(BASE + endpoint, headers: headers, body: body_with_auth.to_json)
      JSON[response.body]
    end
    
    private

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def auth_body
      {
        client_id: ENV['PLAID_ID'],
        secret: ENV['PLAID_SECRET'],
        access_token: ENV['PLAID_ACCESS_TOKEN']
      }
    end
  end
end

