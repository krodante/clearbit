require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '.fetch_all' do
    it 'returns transactions in date descending order' do
      VCR.use_cassette('transactions') do
        transactions = described_class.fetch_all('2018-03-10', '2018-03-12')

        dates = transactions.map(&:date)
        expect(dates.first).to be > dates.last
      end
    end

    it 'loads the domain along with the transaction' do
      VCR.use_cassette('transactions') do
        transactions = described_class.fetch_all('2018-03-10', '2018-03-12')

        expect(transactions.first.domain).to be_a(Domain)
      end
    end
  end

  describe '.set_recurring' do
    it 'does not set recurring on non-payment transactions' do
      VCR.use_cassette('monthly_transactions') do
        transactions = described_class.set_recurring('2018-01-01', '2018-03-12')

        non_recurring = transactions.select { |t| !t.categories.include?('payment') }
        expect(non_recurring.map(&:recurring).uniq).to eq([false])

        recurring = transactions.select { |t| t.categories.include?('payment') }
        expect(recurring.map(&:recurring).uniq).to include(true)
      end
    end
    
    it 'sets recurring attribute on payment transactions' do
      VCR.use_cassette('monthly_transactions') do
        transactions = described_class.set_recurring('2018-01-01', '2018-03-12')
        recurring = transactions.select { |t| t.categories.include?('payment') }
        recurring_name = recurring.select { |t| t.name.include?('automatic'.upcase) }

        previous_month = recurring_name[0].date - 1.month
        possible_dates = [1, 2].flat_map do |date|
          [previous_month, previous_month + date, previous_month - date]
        end

        expect(possible_dates).to include(recurring_name[0].date - 1.month)
      end
    end
  end
end
