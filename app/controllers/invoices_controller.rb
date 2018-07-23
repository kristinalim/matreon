class InvoicesController < ApplicationController
  before_action :authenticate_user!

  # GET /invoices.json
  def index
    # Poll most recent unpaid invoice
    if current_user.invoices.count > 0
      latest_invoice = current_user.invoices.first
      if latest_invoice.status == "unpaid" && latest_invoice.polled_at < 10.seconds.ago
        latest_invoice.poll!
      end
    end

    invoice_search = current_user.invoices.ransack(index_ransack_params)
    @invoices = invoice_search.result

    render json: {invoices: @invoices}
  end

  private

  def index_ransack_params
    params.has_key?(:q) ? params.require(:q).permit(:unpaid) : {}
  end
end
