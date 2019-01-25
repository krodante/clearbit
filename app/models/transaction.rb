class Transaction
  attr_accessor :date, :name, :amount, :recurring, :domain, :categories

  def initialize(date, name, amount, categories, recurring = false)
    @date = date
    @name = name
    @amount = amount
    @categories = categories
    @recurring = recurring
  end

  def self.fetch_all(start_date, end_date)
    plaid_client = Plaid::Client.new
    transactions = plaid_client.transactions(start_date, end_date)

    transactions.map do |transaction|
      combine_data(transaction)
    end.sort_by(&:date).reverse
  end

  def self.combine_data(transaction)
    new_transaction = self.new(Date.parse(transaction['date']), transaction['name'], transaction['amount'], transaction['category'].map(&:downcase))
    new_transaction.domain = Domain.load_domain(new_transaction.name)
    new_transaction
  end

  def self.set_recurring(start_date, end_date)
    transactions = fetch_all(start_date, end_date)
    groups = transactions.group_by(&:name)

    groups.each do |name, grouped_transactions|
      recurring_transactions = grouped_transactions.select { |t| t.categories.include?('payment') }
      recurring_transactions.each_with_index do |current_transaction, i|
        current_transaction.recurring = is_recurring?(i, recurring_transactions, current_transaction) || false
      end
    end

    transactions
  end

  def self.is_recurring?(i, recurring_transactions, current_transaction)
    previous_month = current_transaction.date - 1.month
    previous_dates = [1, 2].flat_map do |date|
      [previous_month, previous_month + date, previous_month - date]
    end
    (recurring_transactions[i..recurring_transactions.count - 1].map(&:date) & previous_dates).present?
  end
end
