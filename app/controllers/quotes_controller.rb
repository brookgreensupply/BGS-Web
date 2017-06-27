class QuotesController < ApplicationController

  def new
    @quote = Quote.new
    @quote.postcode = params[:postcode]
  end

  def create
  end

  private
    def quote_params_for_new
      params.permit(:postcode)
    end
end
