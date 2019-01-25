require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe ':create' do
    it 'redirects back to the form if the start_date is before the end_date' do
      post :create, params: { start_date: '2018-02-01', end_date: '2018-01-01' }

      expect(response).to redirect_to(action: :form)
      expect(response.status).to eq(302)
      expect(response.request.flash[:error]).to include('start date must be before the end date')
    end

    it 'renders a table with transaction data on success' do
      VCR.use_cassette('transactions_controller') do
        post :create, params: { start_date: '2018-01-01', end_date: '2018-03-15'}

        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
      end
    end
  end
end
