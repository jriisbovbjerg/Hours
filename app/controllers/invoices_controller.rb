class InvoicesController < ApplicationController
  before_action :find_invoice, only: [:edit, :update]

  def index
    @invoice = Invoice.new
    @invoices = Invoice.all
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      redirect_to invoices_path, notice: t(:invoice_created)
    else
      @invoices = Invoice.by_name
      render "invoices/index"
    end
  end

  def edit
  end

  def show
    find_invoice
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicesPdf.new(@invoice)
        send_data pdf.render, filename:      "#{timestamp}-#{@invoice.name}-#{@invoice.dates}.pdf",
                                type:        "application/pdf",
                                page_size:   "A4",
                                disposition: "inline"
      end
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to invoices_path, notice: t(:invoice_updated)
    else
      render :edit
    end
  end

  private
  
  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:name, :from_date, :to_date, :payload)
  end
end
