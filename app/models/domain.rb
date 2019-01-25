class Domain
  attr_accessor :domain, :logo, :name

  def initialize(data)
    @domain = data['domain']
    @logo = data['logo']
    @name = data['name']
  end
end