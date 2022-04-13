class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_paramters, if: :devise_controller?

  protected
  	def configure_permitted_paramters
  		#devise_parameter_sanitizer.for(:sign_up) << :fullname
      devise_parameter_sanitizer.permit(:sign_up, keys:[:fullname, :first_name, :last_name])
  		#devise_parameter_sanitizer.for(:account_update) << :fullname << :phone_number << :description << :email << :password
      devise_parameter_sanitizer.permit(:account_update, keys:[:fullname, :first_name, :last_name, :phone_number, :description, :email, :password])
  	end
end
