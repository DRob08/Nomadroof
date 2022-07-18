# To deliver this notification:
#
# AdminNotification.with(post: @post).deliver_later(current_user)
# AdminNotification.with(post: @post).deliver(current_user)

class AdminNotification < Noticed::Base
  # Add your delivery methods
  deliver_by :database
  deliver_by :email, mailer: "NotificationMailer"

  param :reservation

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
