require 'rails_helper'

describe InvoicesController do
  let!(:contribution) { create(:contribution) }
  let!(:user) { contribution.user }

  before do
    sign_in user
  end

  describe "GET index" do
    let!(:previous_invoice) do
      travel_to Time.zone.local(2018, 1, 15) do
        create(:invoice, :paid, user: user)
      end
    end
    let!(:latest_invoice) do
      travel_to Time.zone.local(2018, 2, 15) do
        create(:invoice, :unpaid, user: user)
      end
    end

    it "responds with @invoices for user" do
      get :index, format: :json

      expect(json_data['invoices'].length).to eq(2)
      expect(json_data['invoices'][0]['id']).to eq(latest_invoice.id)
      expect(json_data['invoices'][1]['id']).to eq(previous_invoice.id)
    end

    describe "scoping" do
      it "allows filtering to unpaid invoices" do
        get :index, params: {q: {unpaid: true}}, format: :json

        expect(json_data['invoices'].length).to eq(1)
        expect(json_data['invoices'][0]['id']).to eq(latest_invoice.id)
      end
    end
  end
end
