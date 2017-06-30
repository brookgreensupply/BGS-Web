class Admin::FeatureFlipperController < Comfy::Admin::Cms::BaseController
  def index
    @features = Flipper::Adapters::ActiveRecord::Feature.all.map(&:key)
  end

  def flip
    feature = params[:feature].downcase.gsub(/[^a-z]/,'').to_sym
    if FF[feature].enabled?
      FF[feature].disable
    else
      FF[feature].enable
    end
    which_image = FF[feature].enabled? ? 'flip-on.png' : 'flip-off.png'
    url_for_toggle = ActionController::Base.helpers.asset_path(which_image)
    render json: {feature: feature, enabled: FF[feature].enabled?, image: url_for_toggle}
  end
end
