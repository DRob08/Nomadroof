class UserStepsController < Wicked::WizardController
  before_action :authenticate_user!
  steps :personal, :professional

  def show
    @user = current_user

    logger.debug "User Information -->: #{@user.first_name}"
    render_wizard
  end

  def update
    @user = current_user
    @user.update(user_params)
    render_wizard @user
  end

  def user_params
    params.require(:user).permit(:fullname, :first_name, :last_name, :phone_number, :description, :email, :password, :avatar, :avatar_cache)
  end

end
