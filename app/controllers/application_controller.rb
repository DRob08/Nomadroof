class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_action :configure_permitted_paramters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  rescue_from CanCan::AccessDenied do
    flash[:error] = 'Access denied!'
    redirect_to root_url
  end

  private
    # Redirect back to current page after sign in
    # ref: https://github.com/heartcombo/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || root_path
    end

  protected
  	def configure_permitted_paramters
  		#devise_parameter_sanitizer.for(:sign_up) << :fullname
      devise_parameter_sanitizer.permit(:sign_up, keys:[:fullname, :first_name, :last_name, :role_id])
  		#devise_parameter_sanitizer.for(:account_update) << :fullname << :phone_number << :description << :email << :password
      devise_parameter_sanitizer.permit(:account_update, keys:[:fullname, :first_name, :last_name, :phone_number, :description, :email, :password, :avatar, :avatar_cache])
  	end
end
