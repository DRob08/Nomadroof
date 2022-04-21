class RegistrationsController < Devise::RegistrationsController
	protected
		def update_resource(resource, params)
			resource.update_without_password(params)
		end

		def after_sign_up_path_for(resource)
			edit_user_registration_path
	  end

end
