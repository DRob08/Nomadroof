class UsersController < ApplicationController
	before_action :authenticate_user!
	#load_and_authorize_resource
	def show
		@user = User.find(params[:id])
		@rooms = @user.rooms

		@joined_on = @user.created_at.to_formatted_s(:short)

	  if @user.current_sign_in_at
			logger.debug "User Information -->: #{@user.current_sign_in_at}"
			logger.debug "User Role -->: #{@current_user&.host? }"
	    @last_login = @user.current_sign_in_at.to_formatted_s(:short)
	  else
	    @last_login = 'never'
	  end
	end
end
