# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class CommentNotification < Noticed::Base
  # Add your delivery methods

  deliver_by :database
  deliver_by :email, mailer: "NotificationMailer"

  param :message

  def message
    params[:message].content
  end

  def url
    message_path(params[:message])
  end
end
