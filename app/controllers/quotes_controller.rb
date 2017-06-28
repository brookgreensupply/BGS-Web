class QuotesController < ApplicationController
  include QuotesHelper

  def new
    @quote = if params[:quote] then Quote.new(quote_params_for_new) else Quote.new end
    @quote.postcode = params[:postcode] if !@quote.postcode && params[:postcode]
    @quote.product_type = 'electricity' if params[:commit] == 'Electricity'
    @quote.product_type = 'gas' if params[:commit] == 'Gas'
    @quote.product_type = params[:product_type] if !@quote.product_type && params[:product_type]
    # FIXME: get addresses from Junifer
    @addresses_hash = { 'results' => [{'mprn' => '8815177407', 'meteringPointAddressLine1' => 'derpy derp1'}] }
  end

  def create
    @quote = Quote.new(quote_params_for_create)
    if params[:cost]
      @quote.cost = @quote.usage
      @quote.usage = nil
    end
    @quote.mprn = nil if @quote.product_type == 'electricity'
    @quote.mpan = nil if @quote.product_type == 'gas'
    if @quote.save && false
      redirect_to action: 'show', id: @quote.id
    else
      flash[:alert] = 'Please try again'
      redirect_to action: 'new', postcode: @quote.postcode, product_type: @quote.product_type
    end
  end

  def show
  end

  private
    def quote_params_for_new
      params.require(:quote).permit(:postcode, :product_type)
    end

    def quote_params_for_create
      params.require(:quote).permit( :postcode, :product_type, :address,
                                     :mpan, :mprn,
                                     :usage, :usage_or_cost_period       )
    end
end
