class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Redirects on successful sign in
  def after_sign_in_path_for(resource)
    comfy_admin_cms_path
  end
end
