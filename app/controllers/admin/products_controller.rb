class Admin::ProductsController < Comfy::Admin::Cms::BaseController
  def index
    @electricity_products = ElectricityProduct.all
    @gas_products = GasProduct.all
  end
end
