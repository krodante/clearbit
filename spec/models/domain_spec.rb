require 'rails_helper'

RSpec.describe Domain, type: :model do
  describe '.load_domain' do
    it 'sets a Domain object' do
      VCR.use_cassette('domains') do
        domain = described_class.load_domain('KFC')

        expect(domain).to be_a(Domain)
        expect(domain.name).to eq('KFC')
      end
    end
  end
end
