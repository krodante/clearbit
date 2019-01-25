class TransacationsController < ApplicationController
  def index
    @transactions = Transaction.combine_data
  end
end
