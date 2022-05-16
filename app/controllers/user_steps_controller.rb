class UserStepsController < Wicked::WizardController
  before_action :authenticate_user!
  steps *User.form_steps

  def show
    @user = current_user
    #@user = User.find(params[:id])
    logger.debug "User update -->: #{@user.phone_number}"
    logger.debug "User FName -->: #{@user.first_name}"
    logger.debug "User ID -->: #{@user.id}"
    logger.debug "User Last -->: #{@user.last_name}"
    logger.debug "User EMAIL -->: #{@user.email}"
    logger.debug "User ROLE -->: #{@user.role_name}"
    render_wizard
  end

  def update
    @user = current_user
    @user.update(user_params(step))
  	logger.debug "User update -->: #{@user.phone_number}"
    render_wizard @user
  end

  private
    def redirect_to_finish_wizard
      redirect_to root_url, notice: "Profile Completed"
    end

  def user_params(step)
    permitted_attributes = case step
                          when "personal"
                            [:first_name, :last_name, :email, :phone_number, :description]
                          when "professional"
                            [:phone_number]
                          end

    # params.require(:user).permit(:fullname, :first_name, :last_name, :phone_number, :description, :email, :password, :avatar, :avatar_cache)
    params.require(:user).permit(permitted_attributes).merge(form_step: step)
  end

end
