class Domain
  attr_accessor :domain, :logo, :name

  def initialize(data)
    @domain = data['domain']
    @logo = data['logo']
    @name = data['name']
  end

  def self.load_domain(name)
    clearbit_client = Clearbit::Client.new(ENV['CLEARBIT_API_KEY'])
    new(clearbit_client.domain(name))
  end
end
