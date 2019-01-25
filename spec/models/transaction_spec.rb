require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '.fetch_all' do
    it 'returns transactions in date descending order' do
      VCR.use_cassette('fetch_transactions') do
        transactions = described_class.fetch_all('2018-01-01', '2018-03-15')

        expect(transactions).to be_sorted(by: :date, verse: :desc)
      end
    end
  end
end
