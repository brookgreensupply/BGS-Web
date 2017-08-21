class Admin::ProductsController < Comfy::Admin::Cms::BaseController
  def index
    @electricity_products = ElectricityProduct.all
    @gas_products = GasProduct.all
  end

  def update_electricity_prices
    begin
      csv = File.read(params[:file].path).gsub(/\r\n?/, "\n")
      ElectricityProductUpload.start(csv)
      ElectricityProductUpload.finish
      flash[:notice] = 'New electricity prices available'
    rescue => e
      Rails.logger.warn e.inspect
      flash[:alert] = 'Unable to process electricity prices CSV'
    end
    redirect_to action: 'index'
  end

  def update_gas_prices
    begin
      csv = File.read(params[:file].path).gsub(/\r\n?/, "\n")
      GasProductUpload.start(csv)
      GasProductUpload.finish
      flash[:notice] = 'New gas prices available'
    rescue => e
      Rails.logger.warn e.inspect
      flash[:alert] = 'Unable to process gas prices CSV'
    end
    redirect_to action: 'index'
  end
end
