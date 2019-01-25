class TransactionsController < ApplicationController
  def index
    render :index
  end

  def create
    if Date.parse(valid_params[:start_date]) < Date.parse(valid_params[:end_date])
      @transactions = Transaction.set_recurring(valid_params[:start_date], valid_params[:end_date])

      render :index
    else
      flash[:error] = 'The start date must be before the end date'
      redirect_to transactions_form_url
    end
  end

  def form
    render :form
  end

  private

  def valid_params
    params.permit('start_date', 'end_date')
  end
end
