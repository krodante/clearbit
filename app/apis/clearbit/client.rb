module Clearbit
  class Client
    include HTTParty
    BASE = 'https://company.clearbit.com/v1'.freeze

    def initialize(api_key)
      @api_key = api_key
    end

    def domain(name)
      response = HTTParty.get("#{BASE}/domains/find?name=#{name}", headers: headers)

      json_response = JSON[response.body]
    end

    private

    attr_accessor :api_key

    def headers
      { 'Authorization' => "Bearer #{api_key}" }
    end
  end
end
