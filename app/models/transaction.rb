class Transaction
  attr_accessor :date, :name, :amount, :recurring, :domain

  def initialize(date, name, amount)
    @date = date
    @name = name
    @amount = amount
  end

  def self.fetch_all(start_date, end_date)
    plaid_client = Plaid::Client.new
    transactions = plaid_client.transactions(start_date, end_date)

    @transactions ||= transactions.map do |transaction|
      new_transaction = self.new(transaction['date'], transaction['name'], transaction['amount'])
      new_transaction.domain = load_domain(new_transaction.name)
      new_transaction
    end.sort_by(&:date).reverse
  end

  def self.load_domain(name)
    clearbit_client = Clearbit::Client.new(ENV['CLEARBIT_API_KEY'])
    Domain.new(clearbit_client.domain(name))
  end

  def self.combine_data(start_date, end_date)
    transactions = @transactions || fetch_all(start_date, end_date)
    groups = transactions.group_by(&:name)

    groups.each do |name, transactions|
      i = 0
      while i < transactions.size - 1
        current_transaction = transactions[i]
        next_transaction = transactions[i + 1]
        current_transaction.recurring = is_recurring?(current_transaction, next_transaction)
        i += 1
      end
    end

    transactions
  end

  def self.is_recurring?(current_transaction, next_transaction)
    next_transaction.amount == current_transaction.amount # && Date.parse(next_transaction.date) == Date.parse(current_transaction.date) + 1.month
  end
end
