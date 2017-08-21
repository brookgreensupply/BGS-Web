class QuotesController < ApplicationController
  include QuotesHelper

  def new
    @quote = if params[:quote] then Quote.new(quote_params_for_new) else Quote.new end
    @quote.postcode = params[:postcode] if !@quote.postcode && params[:postcode]
    @quote.product_type = 'electricity' if params[:commit] == 'Electricity'
    @quote.product_type = 'gas' if params[:commit] == 'Gas'
    @quote.product_type = params[:product_type] if !@quote.product_type && params[:product_type]
    if @quote.postcode
      @addresses_hash = @quote.product_type == 'gas' ? mprn_lookup(@quote.postcode) : mpan_lookup(@quote.postcode)
      @addresses_hash = {} unless @addresses_hash
      if !valid_postcode(@quote.postcode)
        flash[:alert] = 'Invalid postcode'
        redirect_to action: 'new'
      end
    end
  end

  def create
    @quote = Quote.new(quote_params_for_create)
    if params[:cost]
      @quote.cost = @quote.usage
      @quote.usage = nil
    end
    @quote.mprn = nil if @quote.product_type == 'electricity'
    @quote.mpan = nil if @quote.product_type == 'gas'

    products = if @quote.product_type == 'electricity'
      pc = @quote.mpan[0..1]
      distributor_id = @quote.mpan[8..9]
      ElectricityProduct.profile_class(pc.to_i).area(distributor_id.to_i)
    elsif @quote.product_type == 'gas'
      gas_postcode = GasPostcode.lookup @quote.postcode
      if gas_postcode
        @zone = gas_postcode.zone
        if @quote.cost
          GasProduct.zone(@zone).spend(@quote.cost)
        else
          GasProduct.zone(@zone).usage(@quote.usage)
        end
      else
        []
      end
    end
    @quote.presented_products = products.to_json

    if products && !products.empty? && @quote.save
      redirect_to action: 'show', id: @quote.id
    else
      flash[:alert] = 'Sorry, no relevant products'
      redirect_to action: 'new', postcode: @quote.postcode, product_type: @quote.product_type
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @products = JSON.parse @quote.presented_products
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
